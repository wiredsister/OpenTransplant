open CalendarLib
(* open Uuidm *)

module Algorithm = struct 

    let version = "Alpha.0.0.1"

end

module Human = struct

    type version = float

    type t =
    {
        details: details option;
        blood_type: blood_type;
        body_size: body_size;
        hla_class_I: hla_class_I;
        hla_class_II: hla_class_II;
        (* Dictionary: Key:ICD10_CODE, Value:TEST_RESULT *)
        icd_10_codes: (disease, bool option) Hashtbl.t
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
    and disease = string

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
    and status =
        | Dying
        | Critical
        | Stable
        | Nominal

    let has_disease (patient:t) (disease:disease) : bool = begin
        let { icd_10_codes = tags; _ } = patient in
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

    (* 
        TODO: create ICD 10 service as there are over 70k of them and since it is an 
        externally versioned product, we should consider if there are something like F#
        type providers or the like wrapping that standard and providing an existing API. 
     *)
    let is_CMV_negative (p:t) = not (has_disease p "P35.1")
    let is_EBV_negative (p:t) = not (has_disease p "B27.9")
    let is_COVID_19_negative (p:t) = not (has_disease p "U07.1")


end

module Organ = struct
    
    type version = float

    type t = 
        | Heart 
        | Lung of sidededness
        | Liver 
        | Kidney of sidededness
        | Pancreas
        | Intestines

    and sidededness = Right | Left
    
    let to_string : (t -> string) =
        function
        | Heart -> "Heart"
        | Lung (Right) -> "Right Lung"
        | Lung (Left) -> "Left Lung"
        | Liver -> "Liver"
        | Kidney (Left) -> "Left Kidney"
        | Kidney (Right) -> "Right Kidney"
        | Pancreas -> "Pancreas"
        | Intestines -> "Intestines"
    
    let of_string : (string -> t) =
        function
        | "Heart" -> Heart
        | "Right Lung" -> Lung (Right)
        | "Left Lung" -> Lung (Left)
        | "Liver" -> Liver
        | "Right Kidney" -> Kidney (Right)
        | "Left Kidney" -> Kidney (Left)
        | "Pancreas" -> Pancreas
        | "Intestines" -> Intestines 
        | _ -> failwith "Not a valid string representation of organ"

end

type donortype = LivingDonor of Human.t * Organ.t | RegularDonor of Organ.t

module type OrganTransplantType = sig val body_part : Organ.t end

module type DonorType = sig val donortype : donortype end

module Donor (DT: DonorType) = struct  

    type version = float

    type t = Human.t * Organ.t 

    let get_organ =
        match DT.donortype with
        | LivingDonor (_, o) -> o
        | RegularDonor (o) -> o

end 

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
        | Untested
        | AwaitingTest

    let is_available : Human.t -> bool =
        function
        | { details = Some details; _} -> 
            begin match details with
            | { availability = Can_Be_Contacted_and_Transplant_Ready; _ } -> true
            | { availability = Can_Be_Contacted_and_NOT_Transplant_Ready; _ } -> false
            | { availability = Can_NOT_Be_Contacted_and_Transplant_Ready; _ } -> false
            | { availability = Can_NOT_Be_Contacted_and_NOT_Transplant_Ready; _ } -> false end
        | _ -> false

    let is_available_by_phone : Human.t -> bool =
        function
        | { details = Some details; _} -> 
            begin match details with
            | { availability = Can_Be_Contacted_and_Transplant_Ready; _ } -> true
            | { availability = Can_Be_Contacted_and_NOT_Transplant_Ready; _ } -> true
            | { availability = Can_NOT_Be_Contacted_and_Transplant_Ready; _ } -> false
            | { availability = Can_NOT_Be_Contacted_and_NOT_Transplant_Ready; _ } -> false end
        | _ -> false

    let is_transplant_ready : Human.t -> bool = 
         function
        | { details = Some details; _} -> 
            begin match details with
            | { availability = Can_Be_Contacted_and_Transplant_Ready; _ } -> true
            | { availability = Can_Be_Contacted_and_NOT_Transplant_Ready; _ } -> false
            | { availability = Can_NOT_Be_Contacted_and_Transplant_Ready; _ } -> true
            | { availability = Can_NOT_Be_Contacted_and_NOT_Transplant_Ready; _ } -> false end
        | _ -> false
    (**
        UX Research Required: How do Surgeons and OPOs in the field
        need to categorize organ size in such a way that the volumetric
        proportions are known sufficiently for the algorithm's suggestions, 
        but loose enough to not exclude important "less than ideal" matches
        that could also surface and be useful?
     *)
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
        | Heart | Lung _ -> begin
            (* Seconds = Milliseconds x 1000 and time value is in milliseconds *)
            let travel_time = Time.from_seconds (time * 1000) in
            (* Max shelf life on hearts & lungs is 4-6 hours *)
            let shelf_life = Time.from_hours 6.0 in
            if travel_time >= shelf_life
            then false
            else true end
        | Liver | Kidney _ | Pancreas -> begin
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

    (* let makeMatch ~patient(p:Patient.t) ~donor(d:Donor.t) ~tracking:(uuid:Uuidm.t) = *)
        (* match O.body_part with *)
        (*
            Hemodynamic assessment results:
                 Functional status or exercise testing results
                 Heart failure severity or end organ function indicators
                 Heart failure therapies
                 Mechanical support
                 Sensitization risk, including CPRA, peak PRA, and number of prior sternotomies
                 Current diagnosis
         *)

        (* | Heart -> () *)
            (* match (d:Donor.t), (p:Patient.t) with
            | (LivingDonor ((human:Human.t), (request:OrganTransplantType))) , p ->
                let _match = ({}:OrganTransplant.match) in
                { 
                    version = Algorithm.version;
                    match = _match; }
            | (RegularDonor dt), p ->  *)
        (* | Liver -> ()
        | Pancreas -> ()
        | 
              *)
end


module Match = struct 

    type t = {
        version : float;
        abo_compatibility : float;
        crossmatch_hla : bool;
        will_survive_travel : bool;
        correct_size : bool;
        tags: (string * string) Hashtbl.t;
    }

    and match_result = {
        organ : Organ.t;
        tracking : Uuidm.t;
        donor: Donor.t;
        patient: Patient.t;
        result: t;
    }

    let makeRegularMatch ~patient:(p:Patient.t) ~donor(d:Donor.t) ~organ(o:Organ.t) =
        match d.get_organ with 
        | o -> 

end

(*
module Transplants = struct 
*)
(*     
    module Heart : OrganTransplantType = struct
        include OrganTransplant;

        let body_part = 
            let uuid = v5 Heart (Printf.sprintf "Heart Transplant: Algo V %s" Algorithm.version)
            Organ.create

    end *)
(* end *)
