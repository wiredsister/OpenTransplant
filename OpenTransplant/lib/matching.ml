open CalendarLib
open Uuidm
open OpenTransplant.Opo

let not x = false && x
let rand = Random.State.make

module Human = struct

    type t =
    {
        details: details;
        blood_type: blood_type;
        vitals: vitals;
        body_size: body_size;
        meld_score: meldscore option;
        peld_score: peldscore option;
        zipcode: zipcode;
        hla_class_I: hla_class_I;
        hla_class_II: hla_class_II;
        (* Dictionary: Key:ICD10_CODE, Value:TEST_RESULT *)
        prognosis_tags: (prognosis, bool option) Hashtbl.t
    }

    and details = 
    {

        name : string;
        email: string;
        primary_phone: string;
        birthdate: Date.t;
        waitlist_start: Date.t;
        availability: availability;

    }
    
    and blood_type = 
        | A_Pos 
        | A_Neg
        | B_Pos
        | B_Neg
        | AB_Pos
        | AB_Neg
        | O_Pos
        | O_Neg

    (**  This is a hypothetical, might be 
        best suited to be bands of kg *)
    and body_size =
        | Infant
        | Toddler
        | Child
        | Small_Female
        | Small_Male
        | Average_Female
        | Average_Male
        | Large_Female
        | Large_Male

    and zipcode = string

    (* TODO: ICD_10_CODE MAPPING *)
    and prognosis = string

    and meldscore = int 

    and peldscore = string

    and availability = 
        | Can_Be_Contacted_and_Transplant_Ready
        | Can_Be_Contacted_and_NOT_Transplant_Ready
        | Can_NOT_Be_Contacted_and_Transplant_Ready
        | Can_NOT_Be_Contacted_and_NOT_Transplant_Ready

    and entrytime = Date.t

    and hla_class_I = string
    and hla_class_II = string

    (* TODO: Research severity grades and how they differ between prognoses *)
    and vitals =
        | Dying
        | Critical
        | Stable
        | Nominal

    (* let is_child (patient:t) : bool =
        match patient.details.birthdate with *)


    let has_disease (patient:t) (disease:prognosis) : bool = begin
        let { prognosis_tags = tags; _ } = patient in
        if Hashtbl.mem tags disease
        then
            let test_results = Hashtbl.find tags disease in
            match test_results with
            | Some results -> results
            (* 
                Is there a reason to distinguish "inconclusive" vs tested and negative? 
                If so, that can be represented here...
            *)
            | None -> false
        (* 
            Is there a reason to distinguish "untested" vs tested and negative? 
            If so, that can be represented here...
        *)
        else false
    end

    let is_CMV_negative (p:t) = not (has_disease p "P35.1")
    let is_EBV_negative (p:t) = not (has_disease p "B27.9")
    let is_COVID_19_negative (p:t) = not (has_disease p "U07.1")


end


module Organ = struct

    type t = 
        | Heart of tracking
        | Lungs of tracking
        | Liver  of tracking
        | Kidneys of tracking
        | Pancreata of tracking
        | Intestines of tracking

    and tracking = {
        identification : Uuidm.t;
        opo: Opo.OPO.t;
    }

end


module type OrganTransplantType = sig val body_part : Organ.t end

module OrganTransplant (O: OrganTransplantType) = struct

    type t =
    {
        travel_time : int;
        donor : t;
        patient : t;
        car_transport_distance_ml: float;
        air_transport_distance_ml: float;
        compatibility: abo_compatibility * hla_crossmatch option
    }

    and abo_compatibility =
        | ABO_Identical of Human.blood_type
        | Minor_Mismatch of Human.blood_type * Human.blood_type
        | Major_Mismatch of Human.blood_type * Human.blood_type


    and hla_crossmatch =
        | NegativeCrossmatch of 
            (Human.hla_class_I * Human.hla_class_I) * (Human.hla_class_II * Human.hla_class_II)
        | PositiveCrossmatch of 
            (Human.hla_class_I * Human.hla_class_I) * (Human.hla_class_II * Human.hla_class_II)

    let is_available (h:Human.t) : bool =
        begin match h.details.availability with
        | Can_Be_Contacted_and_Transplant_Ready -> true
        | Can_Be_Contacted_and_NOT_Transplant_Ready -> true
        | Can_NOT_Be_Contacted_and_Transplant_Ready -> false
        | Can_NOT_Be_Contacted_and_NOT_Transplant_Ready -> false end

    let is_transplant_ready (h:Human.t) : bool = 
        begin match h.details.availability with
        | Can_Be_Contacted_and_Transplant_Ready -> true
        | Can_Be_Contacted_and_NOT_Transplant_Ready -> false
        | Can_NOT_Be_Contacted_and_Transplant_Ready -> true
        | Can_NOT_Be_Contacted_and_NOT_Transplant_Ready -> false end

    let is_comparable_body_type ~donor:(d:Human.t) ~patient:(p:Human.t) : bool =
        begin match d.body_size, p.body_size with
        (* Perfect Matches *)
        | Infant, Infant -> true
        | Toddler, Toddler -> true
        | Child, Child -> true
        | Small_Female, Small_Female -> true
        | Small_Male, Small_Male -> true
        | Average_Male, Average_Male -> true
        | Average_Female, Average_Female -> true
        | Large_Male, Large_Male -> true
        | Large_Female,Large_Female -> true
        (* Suitable Matches *)
        | Small_Female, Child -> true
        | Child, Small_Female -> true
        | Small_Male, Average_Female -> true
        | Average_Female, Small_Male -> true
        | Average_Male, Large_Female -> true
        | Large_Female, Average_Male -> true
        (* Unsuitable Matches *)
        | _ -> false end

    let is_comparably_smaller_body_type ~donor:(d:Human.t) ~patient:(p:Human.t) : bool =
        begin match d.body_size, p.body_size with
        
        (* If patient is a minor *)
        | Infant, Child -> true
        | Child, Toddler -> true
        | Toddler, Child -> true

        (* If patient is a small woman *)
        | Child, Small_Female -> true

        (* If patient is a small man *)
        | Small_Female, Small_Male -> true
        | Child, Small_Male -> true

        (* If patient is a average woman *)
        | Small_Male, Average_Female -> true
        | Small_Female, Average_Female -> true
        | Child, Average_Female -> true

        (* If patient is a average man *)
        | Average_Female, Average_Male -> true
        | Small_Male, Average_Male -> true
        | Small_Female, Average_Male -> true

        (* If patient is a large woman *)
        | Average_Male, Large_Female -> true
        | Average_Female, Large_Female -> true
        | Small_Male, Large_Female -> true

        (* If patient is a large man *)
        | Average_Female, Large_Male -> true
        | Average_Male, Large_Male -> true
        | Large_Female, Large_Male -> true

        (* Not a match *)
        | _ -> false end

    let get_abo_compatibility ~donor:(d:Human.t) ~patient:(p:Human.t) : abo_compatibility =
        begin match d.blood_type, p.blood_type with
        (* Good Matches: A_Pos Patient *)
        | A_Pos, A_Pos -> ABO_Identical A_Pos
        | A_Neg, A_Pos -> Minor_Mismatch (A_Neg, A_Pos)
        | O_Pos, A_Pos -> Minor_Mismatch (O_Pos, A_Pos)
        | O_Neg, A_Pos -> Minor_Mismatch (O_Neg, A_Pos)

        (* Good Matches: A_Neg Patient *)
        | A_Neg, A_Neg -> ABO_Identical A_Neg
        | O_Neg, A_Neg -> Minor_Mismatch (O_Neg, A_Neg)

        (* Good Matches: B_Pos Patient *)
        | B_Pos, B_Pos -> ABO_Identical B_Pos
        | B_Neg, B_Pos -> Minor_Mismatch (B_Neg, B_Pos)
        | O_Pos, B_Pos -> Minor_Mismatch (O_Pos, B_Pos)
        | O_Neg, B_Pos -> Minor_Mismatch (O_Neg, B_Pos)

        (* Good Matches: B_Neg Patient *)
        | B_Neg, B_Neg -> ABO_Identical B_Neg
        | O_Neg, B_Neg -> Minor_Mismatch (O_Neg, B_Neg)

        (* Good Matches: AB_Pos Patient *)
        | AB_Pos, AB_Pos -> ABO_Identical AB_Pos
        | _ as donor, AB_Pos -> Minor_Mismatch (donor, AB_Pos)

        (* Good Matches: AB_Neg Patient *)
        | AB_Neg, AB_Neg -> ABO_Identical AB_Neg
        | A_Neg, AB_Neg -> Minor_Mismatch (A_Neg, AB_Neg)
        | B_Neg, AB_Neg -> Minor_Mismatch (B_Neg, AB_Neg)
        | O_Neg, AB_Neg -> Minor_Mismatch (O_Neg, AB_Neg)

        (* Good Matches: O_Pos Patient *)
        | O_Pos, O_Pos -> ABO_Identical O_Pos
        | O_Neg, O_Pos -> Minor_Mismatch (O_Neg, O_Pos)

        (* Good Matches: O_Neg Patient *)
        | O_Neg, O_Neg -> ABO_Identical O_Neg

        (* Bad Matches *)
        | _ as donor, patient -> Major_Mismatch (donor, patient) end

    let will_survive_travel ~travel_time:(time:int) : bool =
        (* 
            Need to convert distance in miles to 
            hours away in terms of transport. 

            There are many assumptions that have to be made
            here that merit thought and contemplation. 

            For one, what is the method of transport? 
                - Helicopter?
                - Automobile transit? 
                - 3rd Party Fulfilfment? 
                - Do certain organs have consistent providers? 
                - Could we know more about exact transport 
                time depending on provider type? 

         *)
        match O.body_part with
        | Heart | Lungs -> begin
            (* Seconds = Milliseconds x 1000 and time value is in milliseconds *)
            let travel_time = Time.from_seconds (time * 1000) in
            (* Max shelf life on hearts & lungs is 4-6 hours *)
            let shelf_life = Time.from_hours 6.0 in
            if travel_time >= shelf_life
            then false
            else true end
        | Liver | Kidneys | Pancreata -> begin 
            (* Seconds = Milliseconds x 1000 and time value is in milliseconds *)
            let travel_time = Time.from_seconds (time * 1000) in
            (* Max shelf life on hearts & lungs is 4-6 hours *)
            let shelf_life = Time.from_hours 15.0 in
            if travel_time >= shelf_life
            then false
            else true end
        | Intestines -> begin
            (* Seconds = Milliseconds x 1000 and time value is in milliseconds *)
            let travel_time = Time.from_seconds (time * 1000) in
            (* Max shelf life on hearts & lungs is 4-6 hours *)
            let shelf_life = Time.from_hours 24.0 in
            if travel_time >= shelf_life
            then false
            else true end

    let is_baseline_good_match ~donor:(d:Human.t) ~patient:(p:Human.t) : bool =
        begin is_available d && 
            is_transplant_ready d &&
            (* will_survive_travel travel_time && *)
            begin get_abo_compatibility ~donor:d ~patient:p 
                |> function
                | ABO_Identical _ -> true
                | Minor_Mismatch _ -> true
                | Major_Mismatch _ -> false end end

    let is_ABO_identical ~donor:(d:Human.t) ~patient:(p:Human.t) : bool =
            begin get_abo_compatibility ~donor:d ~patient:p 
                |> function
                | ABO_Identical _ -> true
                | Minor_Mismatch _ -> false
                | Major_Mismatch _ -> false end

    (*  
        Model for End-Stage Liver Disease
        
        The MELD score ranges from 6 to 40, and is a measure of how severe a patient's liver disease is. 
        MELD can fluctuate based on your current condition, with variations from a few points as lab values 
        vary to a larger increase if you have an infection or an acute decompensation (worsening of your liver 
        disease).
    *)

    (* 
    
        NOTE: Using this doc to maybe suggest the algo's bands from UNOS normally stand around this: 
        https://www.upmc.com/services/transplant/liver/process/waiting-list/meld-score
    *)
    let has_urgent_MELD_score ~patient:(p:Human.t) : bool =
        match p.meld_score with
        | n when (n >= Some 25) -> true
        | _ -> false

    (*
        Pediatric End-Stage Liver Disease - younger than 12

        PELD is used to estimate relative disease severity and likely survival of patients awaiting 
        liver transplantation. The Growth term in the equation is set to 0.667 when the subject's height 
        or weight is less than 2 S.D. below the mean values for that age.
    *)

    (* For right now, we always assume children are urgent. *)
    let has_urgent_PELD_score ~patient:(p:Human.t) : bool =
        let _ = p.peld_score in
        true

    let is_patient_liver_failing  ~patient:(p:Human.t) =
        has_urgent_MELD_score ~patient:p && has_urgent_PELD_score ~patient:p

    let is_match ~donor:(d:Human.t) ~patient:(p:Human.t) : bool =
        begin match O.body_part with
        | Heart ->
            (* 

                # HRSA - How Are Hearts Matched

                People waiting for a heart transplant are assigned a status code, 
                which indicates how urgently they need a heart. Because organs such 
                as the heart and lungs can survive outside the body for only 4 to 
                6 hours, they are given first to people who live near the hospital 
                where organs are recovered from the donor.

                If no one near the donor is a match for the heart, the transplant team 
                starts searching progressively farther away to identify a recipient. 
                Body size also is especially important in heart matching, as the 
                donor's heart must fit comfortably inside the recipient's rib cage.

                * Source: https://www.organdonor.gov/about/process/matching.html

            *)

            is_baseline_good_match ~patient:p ~donor:d &&
            is_comparable_body_type ~patient:p ~donor:d

        | HeartAndLungs ->

            (* 

                # HRSA - How Are Heart-Lungs Matched

                Candidates for a heart-lung transplant are registered on both the OPTN 
                Heart Waiting List and the OPTN Lung Waiting List. If a donor heart 
                becomes available, the patient will receive a lung to go with it from 
                the same donor. If a lung becomes available, the donor's heart will be 
                given to the heart/lung patient as well.

                Because these organs can survive outside the body for only 4 to 6 hours, 
                they are given first to people near the donor. If no one near the donor 
                is a match for the heart and lungs, the recovery team starts searching 
                farther away.

                * Source: https://www.organdonor.gov/about/process/matching.html

            *)

            is_baseline_good_match ~patient:p ~donor:d &&
            is_comparable_body_type ~patient:p ~donor:d

        | Lungs ->

            (* 

                # HRSA - How Are Lungs Matched

                The lung allocation system uses information such as lab values, test 
                results, and disease diagnosis—to arrive at a number which represents 
                an estimate of the urgency of a candidate's need for transplant and 
                the likelihood of prolonged survival following the transplant. This 
                lung allocation score, and the common factors listed above, are 
                considered to determine the order in which a donated lung is offered 
                to potential recipients.

                Body size and distance between hospitals are especially important 
                because lungs also must fit within the rib cage, and can survive 
                outside the body for only 4 to 6 hours. Lungs are therefore offered 
                first to people near the donor's hospital. If no one near the donor 
                is a match for the lung, the recovery team starts searching 
                progressively farther away.

                * Source: https://www.organdonor.gov/about/process/matching.html

            *)

            is_baseline_good_match ~patient:p ~donor:d &&
            is_comparable_body_type ~patient:p ~donor:d

        | Liver ->

            (* 

                # HRSA - How Are Livers Matched

                Candidates who need a liver transplant are assigned a MELD or PELD score 
                (Model for End-Stage Liver Disease or Pediatric End-Stage Liver Disease) 
                that indicates how urgently they need the organ. A donor liver is offered 
                first to the candidate who matches on the above common elements and has 
                the highest MELD or PELD score first (indicating the most need).

                If the first recipient's surgeon does not accept the organ then the liver 
                is offered to matching patients with the next highest MELD or PELD scores
                 until the organ is accepted. Geographic factors are also taken into 
                 consideration, but livers can remain outside the body for 12 to 15 hours 
                 so they can travel farther than hearts and lungs.

                * Source: https://www.organdonor.gov/about/process/matching.html

            *)

            is_baseline_good_match ~patient:p ~donor:d &&
            is_patient_liver_failing ~patient:p &&
            is_comparable_body_type ~patient:p ~donor:d


        | Kidneys -> 

            (* 

                # HRSA - How Are Kidneys Matched

                The identification of potential recipients for a donor kidney involves the 
                common elements noted above including blood type, length of time on the 
                waiting list, whether the recipient is a child, and whether the body sizes 
                of the donor and recipient are a good match. Other factors used to match 
                kidneys include a negative lymphocytotoxic crossmatch and the number of 
                HLA antigens in common between the donor and the recipient based on tissue 
                typing. Many kidneys can stay outside the body for 36-48 hours so many more 
                candidates from a wider geographic area can be considered in the kidney 
                matching and allocation process than is the case for hearts or lungs.

                * Source: https://www.organdonor.gov/about/process/matching.html

            *)

            is_baseline_good_match ~patient:p ~donor:d &&
            is_ABO_identical ~patient:p ~donor:d &&
            is_comparable_body_type ~patient:p ~donor:d
            (* Huamn.is_child ~patient:p *)

        | Pancreata ->

            (* 

                # HRSA - How Are Pancreata Matched

                Candidates who are waiting for a pancreas transplant are matched to an available 
                organ primarily based on blood type compatibility and the length of time the 
                patient has been on the waiting list. Since most pancreas transplants are 
                performed at the same time as a kidney transplant, it is also necessary to match 
                the kidney using the matching criteria described above for the kidney.

                * Source: https://www.organdonor.gov/about/process/matching.html

            *)
  
            is_baseline_good_match ~patient:p ~donor:d &&
            is_ABO_identical ~patient:p ~donor:d &&
            is_comparable_body_type ~patient:p ~donor:d

        | Intestines ->

            (* 

                # HRSA - How Are Intestines Matched

                When matching the donor intestine to a waiting list candidate, the ABO blood group 
                must be identical because of the higher risk of graft-versus-host-disease (GVHD), 
                a violent immune reaction by the lymphocytes within the donor organ against the 
                recipient's body that can lead to death. Also, the abdominal cavity shrinks up in 
                many patients waiting for an intestinal transplant so the donor must usually be 
                considerably smaller than the recipient so that the intestine will fit into the 
                smaller space. Finally, because intestinal transplant recipients can easily get a 
                severe infection from cytomegalovirus (CMV) and Epstein Barr virus (EBV), patients 
                who have never been exposed to CMV or EBV before are usually matched with donors 
                who are similarly CMV-negative or EBV-negative respectively.

                * Source: https://www.organdonor.gov/about/process/matching.html

            *)
            is_baseline_good_match ~patient:p ~donor:d &&
            is_ABO_identical ~patient:p ~donor:d &&
            Human.is_CMV_negative p && 
            Human.is_EBV_negative p &&
            Human.is_COVID_19_negative p && 
            is_comparably_smaller_body_type ~patient:p ~donor:d

        end
end