open CalendarLib
open Uuidm


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
    (* let has_urgent_MELD_score =
        function
        | patient when (patient.meld_score patient >= Some 25.) -> true
        | _ -> false *)

    (*
        Pediatric End-Stage Liver Disease - younger than 12

        PELD is used to estimate relative disease severity and likely survival of patients awaiting 
        liver transplantation. The Growth term in the equation is set to 0.667 when the subject's height 
        or weight is less than 2 S.D. below the mean values for that age.
    *)

    (* For right now, we always assume children are urgent. *)
    (* let has_urgent_PELD_score =
        function
        | p when p.peld_score 0. -> true
        | _ -> false *)
(* 
    let is_patient_liver_failing =
        function
        | patient -> has_urgent_MELD_score patient && has_urgent_PELD_score patient *)

    (* let is_match ~donor:(d:Donor().t) ~patient:(p:Patient(Organ).t) : bool =
        begin match O.body_part with
        | Heart info ->
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
            let constraints = 
                is_baseline_good_match ~patient:p ~donor:d &&
                is_comparable_body_type ~patient:p ~donor:d && 
                is_transplant_ready ~patient:p
            in

            (* Write to organ tracking database  *)

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

        end *)
end 