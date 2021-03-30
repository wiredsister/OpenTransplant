open CalendarLib
(* open Uuidm *)

module Algorithm = struct 

    exception NotYetImplemented of string

    let version = "Alpha.0.0.1"

end

<<<<<<< HEAD
module Human = struct
=======
module Human = 
struct

    let version = Algorithm.version

    module BodySize = struct 

        type  metric =
        {
            (* meters *)
            height_m: float;
            (* kilograms *)
            weight_kg: float;
            metric_bmi: float;
        }

        type imperial =
        {
            (* feet *)
            height_ft: float;
            (* pounds *)
            weight_lbs: float;
            imperial_bmi: float;
        }

        type stats = 
        | Imperial of imperial
        | Metric of metric
        
        type t =
        | Infant of stats
        | Toddler of stats
        | Male_Child of stats
        | Female_Child of stats
        | Small_Female of stats
        | Small_Male of stats
        | Average_Female of stats
        | Average_Male of stats
        | Large_Female of stats
        | Large_Male of stats

        (** Source: 
        
        https://www.cdc.gov/healthyweight/assessing
        /bmi/childrens_bmi/childrens_bmi_formula.html#:~:text=The
        %20formula%20for%20BMI%20is,to%20convert%20this%20to%20meters
        .&text=When%20using%20English%20measurements%2C%20pounds%20
        should%20be%20divided%20by%20inches%20squared. 
        
        *)
        let getMetric ~height:(height_m:float) ~weight:(weight_kg:float) : metric =
        { 
            weight_kg = weight_kg;
            height_m = height_m;
            metric_bmi = weight_kg /. height_m**2. 
        }

        (** Source: 
        
        https://www.cdc.gov/healthyweight/assessing
        /bmi/childrens_bmi/childrens_bmi_formula.html#:~:text=The
        %20formula%20for%20BMI%20is,to%20convert%20this%20to%20meters
        .&text=When%20using%20English%20measurements%2C%20pounds%20
        should%20be%20divided%20by%20inches%20squared. 
        
        *)
        let getEnglish ~height:(height_ft:float) ~weight:(weight_lbs:float) : imperial =
        { 
            weight_lbs = weight_lbs;
            height_ft = height_ft;
            imperial_bmi = (703. *. weight_lbs) /. height_ft**2.
        }

        let convertImperialtoMetric =
            function
            | { weight_lbs = weight_lbs; height_ft = height_ft; _ } ->
               let metric_weight = weight_lbs /. 2.2046 in
               let metric_height = height_ft *. 0.3048 in
               getMetric ~weight:metric_weight ~height:metric_height

    end

    module Death = struct

        (** In reference to https://github.com/wiredsister/OpenTransplant/issues/33 *)
        type t =           
        | DonationAfterCirculatoryDeath_DCD of mechanism
        | DonationAfterBrainDeath_DBD of mechanism
        | NotReported
        | Ambiguous of mechanism

        (** In reference to https://github.com/wiredsister/OpenTransplant/issues/33 *)
        and mechanism =
        | Gunshot
        | Apoxia
        | Asphyxiation
        | Cardiovascular 
        | BluntInjury
        | Drowning
        | DrugIntoxication
        | Electrical 
        | GunshotWound
        | Stroke
        | NaturalCause
        | Unknown
        | Seizure
        | Sids 
        | Stabbed
        | Other of string
>>>>>>> eec328f... updated constraints for more accurate donor & patient types - interface does not match right now so build is broken

    type version = float

    type t =
    {
        details: details option;
        blood_type: blood_type;
        body_size: BodySize.t;
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

<<<<<<< HEAD
    (* TODO: Research severity grades and how they differ between prognoses *)
    and status =
        | Dying
        | Critical
        | Stable
        | Nominal

    let has_disease (patient:t) (disease:disease) : bool = begin
=======
    and abo_compatibility =
        | ABO_Identical of blood_type
        | Minor_Mismatch of blood_type * blood_type
        | Major_Mismatch of blood_type * blood_type

    and hla_crossmatch =
        | NegativeCrossmatch of 
            (hla_class_I * hla_class_I) * (hla_class_II * hla_class_II)
        | PositiveCrossmatch of 
            (hla_class_I * hla_class_I) * (hla_class_II * hla_class_II)
        | Untested
        | AwaitingTest

    let has_disease (patient:t) (disease:string) : bool = begin
>>>>>>> eec328f... updated constraints for more accurate donor & patient types - interface does not match right now so build is broken
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

<<<<<<< HEAD

end
=======
    type donorinfo = {
        bloodtype: blood_type;
        hla_information: hla_crossmatch;
        birth_date: Date.t;
        body_size: BodySize.t;
        time_of_death: Date.t;
        cold_time_start: Date.t;
        death_mechanism: Death.mechanism;
        death_type: Death.t;
        zipcode: string;
        disease_information: (string, string) Hashtbl.t;
        (* The tags could be where we put racial information, demographic information, 
        or really, any other free floating identifier we want. *)
        tags: (string, string) Hashtbl.t 
    }

    type donortype = 
        | LivingDonor of t * Policy.living_donor_requirements
        | RegularDonor of donorinfo
        | NearDeathDonor of t

    type organ_transplant_type =
        (* Grafting *)
        | HeartGraft of donortype Organ.t
        | KidneyGraft of donortype Organ.t
        | LungGraft of donortype Organ.t
        | LiverGraft of donortype Organ.t
        | IntestinesGraft of donortype Organ.t
        | PancreasGraft of donortype Organ.t
        | BoneMarrowGraft of donortype Organ.t
        | Grafts of organ_transplant_type list

        (* Whole Organ Transplants *)
        | HeartTransplant of donortype Organ.t
        | PancreasTransplant of donortype Organ.t
        | LiverTransplant of donortype Organ.t 
        | IntestinesTransplant of donortype Organ.t
        | SingleKidneyTransplant of donortype Organ.t
        | DualKidneyTransplant of donortype Organ.t
        | BilateralLungTransplant of donortype Organ.t
        | SingleLungTransplant of donortype Organ.t
        | HeartAndLungsTransplant of donortype Organ.t * organ_transplant_type
        | ManyOrganTransplant of organ_transplant_type list

        (* Tissue Transplant *)
        | BoneMarrowTransplant of donortype Organ.t
        | TissueTransplant of donortype Organ.t
        | ManyTissueTransplants of donortype Organ.t list
        | TissueGraft of donortype Organ.t
        | ManyTissueGrafts of donortype Organ.t list
>>>>>>> eec328f... updated constraints for more accurate donor & patient types - interface does not match right now so build is broken

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
<<<<<<< HEAD
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
=======
        | { availability = Can_Be_Contacted_and_Transplant_Ready; _ } -> true
        | { availability = Can_Be_Contacted_and_NOT_Transplant_Ready; _ } -> false
        | { availability = Can_NOT_Be_Contacted_and_Transplant_Ready; _ } -> true
        | { availability = Can_NOT_Be_Contacted_and_NOT_Transplant_Ready; _ } -> false

    let good_fit (m1:BodySize.metric) (m2:BodySize.metric) =
        match m1, m2 with
        { height_m = donor_height; weight_kg = donor_weight; _ },
        { height_m = patient_height; weight_kg = patient_weight; _ } ->
            let height_delta = abs ((int_of_float donor_height) - (int_of_float patient_height)) in
            let weight_delta = abs ((int_of_float patient_weight) - (int_of_float donor_weight)) in
            let policy_weight = (Policy.reasonable_metric_delta_organ_weight |> int_of_float) in
            let policy_height = (Policy.reasonable_metric_delta_organ_height |> int_of_float) in
            weight_delta <= policy_weight || height_delta <= policy_height

    let smaller_fit (m1: BodySize.metric) (m2: BodySize.metric) =
        match m1, m2 with
        | { height_m = donor_height; weight_kg = donor_weight; _ },
          { height_m = patient_height; weight_kg = patient_weight; _ } ->
            let height_delta = donor_height -. patient_height in
            let weight_delta = donor_weight -. patient_weight in
            let policy_weight = Policy.reasonable_metric_delta_organ_weight in
            let policy_height = Policy.reasonable_metric_delta_organ_height in
            weight_delta <= policy_weight || height_delta <= policy_height

    let crunch (m1:BodySize.stats) (m2:BodySize.stats) =
        match m1, m2 with
        | BodySize.Imperial s, BodySize.Imperial s2 -> 
            let converted_1 = BodySize.convertImperialtoMetric s in
            let converted_2 = BodySize.convertImperialtoMetric s2 in
            good_fit converted_1 converted_2
        | BodySize.Metric s, BodySize.Metric s2 -> 
            good_fit s s2
        | BodySize.Metric s, BodySize.Imperial s2 ->
            let converted = BodySize.convertImperialtoMetric s2 in
            good_fit s converted
        | BodySize.Imperial s, BodySize.Metric s2 ->
            let converted = BodySize.convertImperialtoMetric s in
            good_fit converted s2

    let crunchSmallerFit (m1:BodySize.stats) (m2:BodySize.stats) =
        match m1, m2 with    
        | BodySize.Imperial s, BodySize.Imperial s2 -> 
            let converted_1 = BodySize.convertImperialtoMetric s in
            let converted_2 = BodySize.convertImperialtoMetric s2 in
            smaller_fit converted_1 converted_2
        | BodySize.Metric s, BodySize.Metric s2 -> 
            smaller_fit s s2
        | BodySize.Metric s, BodySize.Imperial s2 ->
            let converted = BodySize.convertImperialtoMetric s2 in
            smaller_fit s converted
        | BodySize.Imperial s, BodySize.Metric s2 ->
            let converted = BodySize.convertImperialtoMetric s in
            smaller_fit converted s2


    let is_comparable_body_type ~donor:(d:donorinfo) ~patient:(p:t) : bool =
        begin match d.body_size, p.body_size with
        (* Perfect Matches *)
        | BodySize.Infant m1, BodySize.Infant m2 -> crunch m1 m2
        | BodySize.Toddler m1, BodySize.Toddler m2 -> crunch m1 m2
        | BodySize.Male_Child m1, BodySize.Male_Child m2 -> crunch m1 m2
        | BodySize.Female_Child m1, BodySize.Female_Child m2 -> crunch m1 m2
        | BodySize.Small_Female m1, BodySize.Small_Female m2 -> crunch m1 m2
        | BodySize.Small_Male m1, BodySize.Small_Male m2 -> crunch m1 m2
        | BodySize.Average_Male m1, BodySize.Average_Male m2 -> crunch m1 m2
        | BodySize.Average_Female m1, BodySize.Average_Female m2 -> crunch m1 m2
        | BodySize.Large_Male m1, BodySize.Large_Male m2 -> crunch m1 m2
        | BodySize.Large_Female m1, BodySize.Large_Female m2 -> crunch m1 m2

        (* Suitable Matches *)
        | BodySize.Female_Child m1, BodySize.Toddler m2 -> crunch m1 m2
        | BodySize.Toddler m1, BodySize.Female_Child m2 -> crunch m1 m2

        | BodySize.Small_Female m1, BodySize.Male_Child m2 -> crunch m1 m2
        | BodySize.Male_Child m1, BodySize.Small_Female m2 -> crunch m1 m2

        | BodySize.Small_Male m1, BodySize.Average_Female m2 -> crunch m1 m2
        | BodySize.Average_Female m1, BodySize.Small_Male m2 -> crunch m1 m2

        | BodySize.Average_Male m1, BodySize.Large_Female m2 -> crunch m1 m2
        | BodySize.Large_Female m1, BodySize.Average_Male m2 -> crunch m1 m2
>>>>>>> eec328f... updated constraints for more accurate donor & patient types - interface does not match right now so build is broken

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

<<<<<<< HEAD


    let is_comparably_smaller_body_type ~donor:(d:Human.t) ~patient:(p:Human.t) : bool =
=======
    let is_comparably_smaller_body_type ~donor:(d:donorinfo) ~patient:(p:t) : bool =
>>>>>>> eec328f... updated constraints for more accurate donor & patient types - interface does not match right now so build is broken
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
<<<<<<< HEAD

    let get_abo_compatibility ~donor:(d:Human.t) ~patient:(p:Human.t) : abo_compatibility =
        begin match d.blood_type, p.blood_type with
=======
    
    let get_abo_compatibility ~donor:(d:blood_type) ~patient:(p:t) : abo_compatibility =
        begin match d, p.blood_type with
>>>>>>> eec328f... updated constraints for more accurate donor & patient types - interface does not match right now so build is broken
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

<<<<<<< HEAD
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
=======
end

module type OrganTransplantType = sig val transferring : Human.organ_transplant_type end

module Transit = struct
            
    open Cohttp_lwt_unix
    open Lwt.Infix
    open Yojson.Basic
    open Yojson.Basic.Util
    open Policy
    open Human

    let version = Algorithm.version

    type zipcode = string

    type distance = Location.t

    type capability = 
        | Helicopter
        | VehicleTransport
        | RailTransport
        | DroneTransport
        | CommercialAirlineTransport
        | Other of string
        | CombinedPotential of capability list
        | Unknown

    let expected_transit_capability = 
        CombinedPotential [VehicleTransport; CommercialAirlineTransport]

    module Location = struct

        type t = 
        {
            latitude : float;
            longitude : float;
            name : string;
            zipcode : string;
        }

    end

    module GeoLocationClient = struct

        exception GeoLocationClientException of string
        
        (**
            # EXAMPLE RESPONSE JSON:

            [{
            "place_id":237727585,
            "licence":"Data © OpenStreetMap contributors, ODbL 1.0. https://osm.org/copyright",
            "boundingbox":["28.860372062704","29.180372062704","-81.128973611378","-80.808973611378"],
            "lat":"29.02037206270398",
            "lon":"-80.96897361137782",
            "display_name":"Volusia County, Florida, 32168, United States of America",
            "place_rank":21,
            "category":"place",
            "type":"postcode",
            "importance":0.33499999999999996,
            "address":{
                "county":"Volusia County",
                "state":"Florida",
                "postcode":"32168",
                "country":"United States of America",
                "country_code":"us"
                }
            }] 
        *)

        (** Parse Location.t from JSON response *)
        let extract (json:string) : Location.t =
            try begin
                let name = 
                    from_string json
                    |> index 0
                    |> fun j -> [ j ]
                    |> filter_member "display_name"
                    |> filter_string
                    |> List.hd
                in
                let lat =
                    from_string json
                    |> index 0
                    |> fun j -> [ j ]
                    |> filter_member "lat"
                    |> filter_string
                    |> List.hd
                    |> float_of_string
                in
                let lon =
                    from_string json
                    |> index 0
                    |> fun j -> [ j ]
                    |> filter_member "lon"
                    |> filter_string
                    |> List.hd
                    |> float_of_string
                in
                let zipcode = 
                    from_string json
                    |> index 0
                    |> fun j -> [ j ]
                    |> filter_member "address"
                    |> filter_member "postcode"
                    |> filter_string
                    |> List.hd
                in
                {
                    name = name;
                    zipcode = zipcode;
                    latitude = lat;
                    longitude = lon;
                }
            end with _ -> raise @@ Yojson.Json_error json
            
        (** Construct URI for talking to open map data for location information over HTTPS *)
        let get_open_map_url (zip:string) : Uri.t = 
            Printf.sprintf "https://nominatim.openstreetmap.org/search?q=%s&format=jsonv2&addressdetails=1" zip
            |> Uri.of_string

        (** Make HTTP Request and return location data in promise value *)
        let get_location_data (zipcode:string) : Location.t Lwt.t =
                Client.get @@ get_open_map_url zipcode  
                >>= fun (resp, body) ->
                match resp.status with
                | `OK ->
                    begin
                        try begin
                        body |> Cohttp_lwt.Body.to_string >|= fun str_body ->
                            extract str_body
                        end with _ -> raise @@ GeoLocationClientException zipcode
                    end
                | _ -> raise @@ GeoLocationClientException zipcode

    end

    module GeoDistanceClient = struct

        exception GeoDistanceClientException of Location.t * Location.t

        (** Construct URI for talking to a to b open map tool over HTTPS *)
        let get_distance_via_map_tool_url (local1:Location.t) (local2:Location.t) : Uri.t =
            Printf.sprintf 
                "https://www.freemaptools.com/ajax/route-service.php?lat1=%s&lng1=%s&lat2=%s&lng2=%s"
                (string_of_float local1.latitude)
                (string_of_float local1.longitude)
                (string_of_float local2.latitude)
                (string_of_float local2.longitude)
            |> Uri.of_string

        (* 
            { 
                "hints" : { 
                    "visited_nodes.sum" : 893,
                    "visited_nodes.average": 893.0 
                },
                "info": {
                    "copyrights":["GraphHopper", "OpenStreetMap contributors"],
                    "took":16
                },
                "paths":[
                    {
                        "distance": 1293834.883,
                        "weight": 64697.72454,
                        "time":45289555,
                        "transfers":0,
                        "points_encoded":true,
                        "bbox":[-81.686619,29.011285, -77.100354,38.838456]
                    }
                ]
            }
        *)

        (** Parse distance value from JSON response *)
        let extract (json:string) : float =
                [ from_string json ]
                |> filter_member "paths"
                |> filter_member "distance"
                |> filter_string
                |> List.hd
                |> float_of_string

        (** Make HTTP Request and return distance result in miles in promise value *)
        let get_distance (zip1:string) (zip2:string) : float Lwt.t =
            let location1 = GeoLocationClient.get_location_data zip1 in
            let location2 = GeoLocationClient.get_location_data zip2 in
            let locations = Lwt.both location1 location2 in
            Lwt.bind locations (fun (local1, local2) -> 
                let url = get_distance_via_map_tool_url local1 local2 in
                Client.get url >>= fun (resp, body) ->
                match resp.status with
                | `OK ->
                    begin 
                        try begin 
                            body |> Cohttp_lwt.Body.to_string >|= fun str_body ->
                                extract str_body
                        end with _ -> raise @@ GeoDistanceClientException (local1, local2)
                    end
                | _ -> raise @@ GeoDistanceClientException (local1, local2))

    end


    module TTL = struct 
    
        let rec get : organ_transplant_type -> Time.t = 
        function
        | HeartTransplant _ -> ShelfLife.heart
        | HeartAndLungsTransplant (_,_) -> ShelfLife.heart
        | HeartGraft _ -> ShelfLife.heart

        | BilateralLungTransplant _ -> ShelfLife.lungs
        | SingleLungTransplant _ -> ShelfLife.lungs
        | LungGraft _ -> ShelfLife.lungs
        
        | LiverGraft _ -> ShelfLife.tissue
        | LiverTransplant _ -> ShelfLife.liver

        | IntestinesGraft _ -> ShelfLife.tissue
        | IntestinesTransplant _ -> ShelfLife.intestines

        | PancreasGraft _ -> ShelfLife.tissue
        | PancreasTransplant _ -> ShelfLife.pancreas

        | DualKidneyTransplant _
        | SingleKidneyTransplant _ -> ShelfLife.kidney
        | KidneyGraft _ -> ShelfLife.tissue

        | BoneMarrowGraft _
        | BoneMarrowTransplant _ -> ShelfLife.tissue

        | ManyOrganTransplant organs ->
            let iterate = (get >> Time.hour >> float_of_int) in
            List.fold_left (fun (acc:float) (x:organ_transplant_type) ->
                let iter = iterate x in
                if acc > iter
                then acc
                else iter) (iterate @@ List.hd organs) (List.tl organs)
            |> Time.from_hours

        | Grafts organs -> 
            let iterate = (get >> Time.hour >> float_of_int) in
            List.fold_left (fun (acc:float) (x:organ_transplant_type) ->
                let iter = iterate x in
                if acc > iter
                then acc
                else iter) (iterate @@ List.hd organs) (List.tl organs)
            |> Time.from_hours
        
        | TissueGraft _ -> ShelfLife.tissue
        | TissueTransplant _ -> ShelfLife.tissue
        | ManyTissueGrafts _ -> ShelfLife.tissue
        | ManyTissueTransplants _ -> ShelfLife.tissue
    end
end

module OrganTransplant(TYPE: OrganTransplantType) =
struct
    type t =
        {
        transplant_id: Uuidm.t;
        donor : Human.donorinfo;
        patient : Human.t;
        transit_capability: Transit.capability;
        car_transport_distance_ml: float;
        air_transport_distance_ml: float;
        estimated_travel_time: int;
        abo_compatibility: Human.abo_compatibility; 
        hla_crossmatch: Human.hla_crossmatch option;
        status: status;
        illness_compatibility: illness_compatibility option;
        rules: rules;
        seeking: Human.organ_transplant_type; }

    and illness_compatibility = (Human.disease -> Human.t -> bool)
    (** Values for Rule: rule name -> version of rule -> logic of rule 
        applied to transplant to show if rule is followed or not *)
    and rules = (string * string * (t-> bool)) list

    and status =
        | PreMatch
        | InTesting
        | InTransit
        | PreSurgery
        | PostSurgery
        | UltimateOutcome

    let rec will_survive_travel ~time:(time:float) ?organ:(organ=TYPE.transferring) () : bool =
        begin match (organ:Human.organ_transplant_type) with
        | HeartTransplant _ ->
            begin
            (* Seconds = Milliseconds x 1000 and time value is in milliseconds *)
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.heart
>>>>>>> eec328f... updated constraints for more accurate donor & patient types - interface does not match right now so build is broken
            then false
            else true end
        | Liver | Kidney _ | Pancreas -> begin
            (* Seconds = Milliseconds x 1000 and time value is in milliseconds *)
<<<<<<< HEAD
            let travel_time = Time.from_seconds (time * 1000) in
            (* Max shelf life on hearts & lungs is 4-6 hours *)
            let shelf_life = Time.from_hours 15.0 in
            if travel_time >= shelf_life
=======
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.heart
>>>>>>> eec328f... updated constraints for more accurate donor & patient types - interface does not match right now so build is broken
            then false
            else true end
        | Intestines -> begin
            (* Seconds = Milliseconds x 1000 and time value is in milliseconds *)
<<<<<<< HEAD
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
=======
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.heart
            then false
            else true end
        | LungGraft _ ->
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.lungs
            then false
            else true end
        | BilateralLungTransplant _ ->
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.lungs
            then false
            else true end
        | SingleLungTransplant _ -> 
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.lungs
            then false
            else true end
        | LiverTransplant _ ->
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.liver
            then false
            else true end
        | LiverGraft _ ->
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.liver
            then false
            else true end
        | SingleKidneyTransplant _ ->
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.kidney
            then false
            else true end
        | DualKidneyTransplant _ ->
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.kidney
            then false
            else true end
        | KidneyGraft _ -> 
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.kidney
            then false
            else true end
        | PancreasGraft _ ->
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.pancreas
            then false
            else true end
        | PancreasTransplant _ -> 
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.pancreas
            then false
            else true end
        | IntestinesTransplant _ ->
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.intestines
            then false
            else true end
        | BoneMarrowTransplant _ ->
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.intestines
            then false
            else true end
        | BoneMarrowGraft _ ->
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.intestines
            then false
            else true end
        | IntestinesGraft _ -> 
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.intestines
            then false
            else true end
        | TissueTransplant _ ->
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.tissue
            then false
            else true end
        | ManyTissueTransplants _ ->
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.tissue
            then false
            else true end
        | TissueGraft _ ->
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.tissue
            then false
            else true end
        | ManyTissueGrafts _ -> 
            begin
            let travel_time = Time.from_seconds (time *. 1000. |> int_of_float) in
            if travel_time >= Policy.ShelfLife.tissue
            then false
            else true end
        | ManyOrganTransplant organs -> begin
            List.fold_left (fun acc o -> acc && (will_survive_travel ~time ~organ:o ())) true organs
        end
        | Grafts organs -> begin
            List.fold_left (fun acc o -> acc && (will_survive_travel ~time ~organ:o ())) true organs
        end
    end

    let is_ABO_partial_match ~donor:(d:Human.blood_type) ~patient:(p:Human.t) : bool =
        begin
        let compatibility = Human.get_abo_compatibility ~donor:d ~patient:p in 
        match compatibility with
        | ABO_Identical _ -> true
        | Minor_Mismatch _ -> true
        | Major_Mismatch _ -> false end

    let is_ABO_identical ~donor:(d:Human.blood_type) ~patient:(p:Human.t) : bool =
        begin
        let compatibility = Human.get_abo_compatibility ~donor:d ~patient:p in
        match compatibility with
        | ABO_Identical _ -> true
        | Minor_Mismatch _ -> false
        | Major_Mismatch _ -> false end

    let rec has_correct_size ~donor:(d:Human.donorinfo) ~patient:(p:Human.t) ?organ:(organ=TYPE.transferring) () : bool =
        let donor_body_size = d.body_size in
        begin match organ with
        | HeartAndLungsTransplant _ -> Human.is_comparable_body_type ~donor:d ~patient:p
        | HeartTransplant _ -> Human.is_comparable_body_type ~donor:d ~patient:p
        | BilateralLungTransplant _ -> Human.is_comparable_body_type ~donor:d ~patient:p
        | SingleLungTransplant _ ->  Human.is_comparable_body_type ~donor:d ~patient:p

        | PancreasTransplant _ -> Human.is_comparable_body_type ~donor:d ~patient:p
        | DualKidneyTransplant _ -> Human.is_comparable_body_type ~donor:d ~patient:p
        | SingleKidneyTransplant _ -> Human.is_comparable_body_type ~donor:d ~patient:p
        | LiverTransplant _ -> Human.is_comparable_body_type ~donor:d ~patient:p

        | IntestinesTransplant _ -> Human.is_comparably_smaller_body_type ~donor:d ~patient:p

        | HeartGraft _ -> true
        | LungGraft _ -> true
        | LiverGraft _ -> true
        | IntestinesGraft _ -> true
        | PancreasGraft _ -> true
        | KidneyGraft _ -> true
        | BoneMarrowGraft _ -> true
        (* This is probably overly simplistic, but may end up treating tissue as essentially 
        non-processable in this system, since tissue logistics and fulfillment are completely 
        separate from OPTN oversight. *)
        | TissueTransplant _ -> true
        | BoneMarrowTransplant _ -> true
        | Grafts _ -> true
        | TissueGraft _ -> true
        | ManyTissueGrafts _ -> true
        | ManyTissueTransplants _ -> true

        | ManyOrganTransplant organs ->
            List.fold_left (fun acc o -> acc && has_correct_size ~donor:d ~patient:p ~organ:o ()) true organs
        end

    let create ~donor:(d:Human.donorinfo)  ~patient:(p:Human.t) : t Lwt.t =
        let geo_response : (float * int) Lwt.t = 
            GeoDistanceClient.get_distance (p.details.zipcode: string) (d.zipcode: string) 
        in
        begin Lwt.bind geo_response (fun (distance, time) ->
            Lwt.return {
                transplant_id = Algorithm.gen_uuid();
                donor = d;
                patient = p;
                transit_capability = Transit.expected_transit_capability;
                car_transport_distance_ml = distance;
                air_transport_distance_ml = distance;
                estimated_travel_time = time;
                abo_compatibility = Human.get_abo_compatibility ~donor:d.bloodtype ~patient:p;
                hla_crossmatch = None;
                illness_compatibility = None;
                rules = [];
                status = PreMatch;
                seeking = TYPE.transferring; }) 
            end

>>>>>>> eec328f... updated constraints for more accurate donor & patient types - interface does not match right now so build is broken
end


<<<<<<< HEAD
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
=======
        type seeking = Human.organ_transplant_type list

        let seeking = INFO.seeking

        type accepted = Human.organ_transplant_type list

        let accepted = INFO.accepted

        let waitlist_number : int32 = Int32.minus_one

        type t = Human.t * Uuidm.t

        let human = INFO.clinical_details

        let get : t = (human, INFO.id)

end

module type DonorType = 
    sig 
        val donortype : Human.donortype
        val accepted_by_recipients : Human.organ_transplant_type list
        val viable_organs : Human.organ_transplant_type list
        val id : Uuidm.t
        val current_cases : Human.organ_transplant_type list
    end

module Donor (TYPE: DonorType) = struct 

    type version = string

    type t = 
    {
        id: Uuidm.t;
        current_cases: Human.organ_transplant_type list;
        donortype: Human.donortype;
        accepted_by_recipients: Human.organ_transplant_type list; 
        viable_organs : Human.organ_transplant_type list;
    }

    let donortype = TYPE.donortype
    let transferring = TYPE.viable_organs
    let accepted : Human.organ_transplant_type list = []
    let cases : Human.organ_transplant_type list = []

    let get_details : t = {
        id = Algorithm.gen_uuid();
        current_cases = cases;
        donortype = donortype;
        accepted_by_recipients = accepted;
        viable_organs = transferring;
>>>>>>> eec328f... updated constraints for more accurate donor & patient types - interface does not match right now so build is broken
    }

    let makeRegularMatch ~patient:(p:Patient.t) ~donor(d:Donor.t) ~organ(o:Organ.t) =
        match d.get_organ with 
        | o -> 

<<<<<<< HEAD
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
=======
    let version = Algorithm.version;

    type t = {
        version : string;
        match_id : Uuidm.t;
        abo_compatibility : bool;
        crossmatch_hla_compatibility : bool;
        illness_compatibility : bool;
        rule_compatibility : bool;
        will_survive_travel : bool;
        correct_size : bool;
        tags: (string, string) Hashtbl.t;
    }

    let create ~donor:(d:Human.donortype) ~patient:(p:Human.t) (o:Human.organ_transplant_type) : t Lwt.t =
        let module TransplantOrgan = struct let transferring = o; end in
        let module ProposedTransplant = OrganTransplant(TransplantOrgan) in
        let module ProspectiveDonor =
            struct
                let version = Algorithm.version
                let id = Algorithm.gen_uuid ()
                let current_cases = [o]
                let donortype = d
                let accepted_by_recipients = [o]
                let viable_organs = [o]
            end in
        let module RegisteredDonor = Donor(ProspectiveDonor) in
        let module ProspectivePatient = 
        struct 
            let version = Algorithm.version
            let id = Algorithm.gen_uuid ()
            let waitlist_number = Int32.minus_one
            let clinical_details = p
            let accepted = [o]
            let seeking = o;
        end in
        let module Recipient = Patient(ProspectivePatient) in
        match d with
        | RegularDonor (info:Human.donorinfo) ->
            begin
                let transplant = ProposedTransplant.create ~donor:info ~patient:p in
                Lwt.bind transplant (fun t ->
                match t with
                | { abo_compatibility = abo_compatibility;
                    illness_compatibility = _;
                    air_transport_distance_ml = air_transport_distance_ml;
                    _ } ->
                let air_time = air_transport_distance_ml /. 460. in
                Lwt.return {
                    version = Algorithm.version;
                    match_id = Algorithm.gen_uuid();
                    abo_compatibility = 
                        begin match abo_compatibility with
                        | ABO_Identical _ -> true
                        | _ -> false end;
                    (*TODO: Implement calling API here *)
                    crossmatch_hla_compatibility = true;
                    (* TODO: Implement calling ICD-10 Service or filtering out 
                    known ones depending on the case... *)
                    illness_compatibility = true;
                    rule_compatibility = true;
                    (* 
                        TODO! HAVE THIS BE PARAMETERIZED BY TRANSIT CAPABILITES
                        Right now it's assuming commercial airline in airmiles,
                        because of recent regulation. Commercial airlines typically fly
                        460 – 575 mph so I will assume 460mph worst case. We divide 
                        the miles by this number to get hours.
                        *)
                    will_survive_travel = ProposedTransplant.will_survive_travel ~time:(air_time) ();
                    correct_size = ProposedTransplant.has_correct_size ~patient:p ~donor:info ();
                    tags = Hashtbl.create 100;
                })
            end
        | LivingDonor _ -> failwith (Printf.sprintf "Living Donor not yet implemented in %s" Algorithm.version)
        | NearDeathDonor _ -> failwith (Printf.sprintf "Living Donor not yet implemented in %s" Algorithm.version)
        
end
>>>>>>> eec328f... updated constraints for more accurate donor & patient types - interface does not match right now so build is broken
