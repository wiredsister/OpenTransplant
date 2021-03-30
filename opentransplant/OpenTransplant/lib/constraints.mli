open CalendarLib
open Uuidm

module Algorithm :
sig 

    val version : string
    val running_instance : Uuidm.t

end

module Policy : 
sig

    val version : string

    (* TODO: Research required on actual living donor requirements... 
       Are there more requirements? *)
    type living_donor_requirements = 
    {
        full_medical_eval_passed : bool;
        physical_examination_passed : bool;
        psychosocial_examination_passed : bool;
    }

    (* TODO: Research required on actual neardeath donor requirements *)
    type near_death_donor_requirements = 
    {
        donorfamily_approval: bool;
        donor_provider_coordination: bool;
    }

    val reasonable_metric_delta_organ_height : float
    val reasonable_metric_delta_organ_width : float

    module ShelfLife : 
    sig

        val heart : float

        val lungs : float

        val liver : float

        val intestines : float

        val pancreas : float

        val kidney : float

        val tissue : float

    end

end

module Organ : 
sig
    
    val version : string

    module Sidedness : 
    sig 
    
        type t = Right | Left 

        val to_string : t -> string
        
        val of_string : string -> t

    end

    type cold_time = float ref
    type warm_time = float ref

    
    type organ_details = 
    {
        cold_time : cold_time;
        warm_time : warm_time;
        tracking_id : Uuidm.t;
        medical_notes: string;
        organ_type: t;
        sidedness: Sidedness.t option;
    }

    type _ t = 
    | Heart : string -> organ_details t
    | Lung : Sidedness.t * string -> organ_details t
    | Liver : string -> organ_details t
    | Kidney : Sidedness.t * string -> organ_details t
    | Pancreas : string -> organ_details t
    | Intestines : string -> organ_details t
    | BoneMarrow : string -> organ_details t
    | Bone : string -> organ_details t
    | Tendon : string -> organ_details t
    | VeinsOrArteries : string -> organ_details t
    | HeartValves : string -> organ_details t
    | Corneas : (Sidedness.t * string) -> organ_details t
    | Graft : string -> organ_details t

    val to_string : 'organ_or_graft t -> string
    
    val of_string : string -> 'organ_or_graft t

end

module Human : 
sig

    val version : string

    type  metric =
    {
        (* meters *)
        height_m: float;
        (* kilograms *)
        weight_kg: float;
        metric_bmi: float;
    }

    type english =
    {
        (* feet *)
        height_ft: float;
        (* pounds *)
        weight_lbs: float;
        english_bmi: float;
    }

    type stats =
    | English of english
    | Metric of metric

    module Death : 
    sig

        type mechanism =
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

        type t =
        | DonationAfterCirculatoryDeath_DCD of mechanism
        | DonationAfterBrainDeath_DBD of mechanism
        | NotReported
        | Ambiguous of mechanism

    end

    type disease = string

    type availability =
    | Can_Be_Contacted_and_Transplant_Ready
    | Can_Be_Contacted_and_NOT_Transplant_Ready
    | Can_NOT_Be_Contacted_and_Transplant_Ready
    | Can_NOT_Be_Contacted_and_NOT_Transplant_Ready
    | Unreported

    type hla_class_I = string
    type hla_class_II = string

    type details =
    {
        pronouns: string;
        ssn: string;
        preferred_name: string;
        first_name : string;
        middle_name: string;
        last_name: string;
        email: string;
        primary_phone: string;
        zipcode: string;
    }
    
    type blood_type = 
    | A_Pos 
    | A_Neg
    | B_Pos
    | B_Neg
    | AB_Pos
    | AB_Neg
    | O_Pos
    | O_Neg

    type body_size =
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

    type abo_compatibility =
    | ABO_Identical of blood_type
    | Minor_Mismatch of blood_type * blood_type
    | Major_Mismatch of blood_type * blood_type

    type hla_crossmatch =
    | NegativeCrossmatch of (hla_class_I * hla_class_I) * (hla_class_II * hla_class_II)
    | PositiveCrossmatch of (hla_class_I * hla_class_I) * (hla_class_II * hla_class_II)
    | Untested
    | AwaitingTest

    type illness_compatibility = disease -> t -> bool

    type rules = (t -> bool) list

    type t =
    {
        details: details option;
        blood_type: blood_type;
        body_size: body_size;
        hla_class_I: hla_class_I;
        hla_class_II: hla_class_II;
        icd_10_codes: (disease, bool option) Hashtbl.t;
        birthdate: Date.t;
        waitlist_start: Date.t;
        availability: availability;
    }

    type donortype =
    | LivingDonor of t * Policy.living_donor_requirements
    | RegularDonor of t
    | NearDeathDonor of t * Policy.near_death_donor_requirements

    type organ_transplant_type =
    | HeartGraft of donortype Organ.t
    | KidneyGraft of donortype Organ.t
    | LungGraft of donortype Organ.t
    | LiverGraft of donortype Organ.t
    | IntestinesGraft of donortype Organ.t
    | PancreasGraft of donortype Organ.t
    | BoneMarrowGraft of donortype Organ.t
    | Grafts of organ_transplant_type list
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
    | BoneMarrowTransplant of donortype Organ.t
    | TissueTransplant of donortype Organ.t
    | ManyTissueTransplants of donortype Organ.t list
    | TissueGraft of donortype Organ.t
    | ManyTissueGrafts of donortype Organ.t list

    val has_disease : t -> disease -> bool

    val is_available : t -> bool

    val is_available_by_phone : t -> bool

    val is_transplant_ready : t -> bool

    val is_comparable_body_type : t -> t -> bool

    val is_comparably_smaller_body_type : t -> bool

    val get_abo_compatibility : t -> abo_compatibility

    val will_survive_travel : int -> organ_transplant_type option -> bool

    val is_ABO_identical : t -> t -> bool

    val is_ABO_partial_match : t -> t -> bool

    val is_CMV_negative : t -> bool

    val is_EBV_negative : t -> bool

    val is_COVID_19_negative : t -> bool

end

module Transit : 
sig

    val version : string

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

    type distance_compatibility =
    | WithinServiceArea
    | OutOfScope
    | NotPossible

    module TTL : 
    sig 

        val get : Human.organ_transplant_type -> float

    end

end

module type OrganTransplantType =

    sig val transfering : Human.organ_transplant_type end
    
    module OrganTransplant(TYPE: OrganTransplantType) : 

    sig

    type version = string

    val version : string

    val transfering : Human.organ_transplant_type

    type hla_crossmatch =
    | NegativeCrossmatch of 
        (Human.hla_class_I * Human.hla_class_I) * (Human.hla_class_II * Human.hla_class_II)
    | PositiveCrossmatch of 
        (Human.hla_class_I * Human.hla_class_I) * (Human.hla_class_II * Human.hla_class_II)
    | Untested
    | AwaitingTest

    type abo_compatibility =
    | ABO_Identical of Human.blood_type
    | Minor_Mismatch of Human.blood_type * Human.blood_type
    | Major_Mismatch of Human.blood_type * Human.blood_type

    type illness_compatibility = Human.disease -> Human.t -> bool
    type rules = (Human.t -> bool) list
    type distance_compatibility = Transit.distance_compatibility

    type t =
        {
        transplant_id: Uuidm.t;
        donor : Human.donortype;
        patient : Human.t;
        transit_capability: Transit.capability;
        car_transport_distance_ml: float;
        air_transport_distance_ml: float;
        abo_compatibility: Human.abo_compatibility; 
        hla_crossmatch: Human.hla_crossmatch;
        illness_compatibility: illness_compatibility option;
        rules: rules option;
        seeking: Human.organ_transplant_type; }

end

module PatientType =
    sig 
        val seeking : Human.organ_transplant_type 
        val accepted : Human.organ_transplant_type list
        val waitlist_number : int32
        val id : Uuidm.t
        val clinical_details : Human.t
    end
    
    module Patient(INFO: PatientType) :

    sig

        type version = string

        type t = Human.t

        val seeking : Human.organ_transplant_type

        val version : string

        val t : Human.t

        val create : Human.t -> t

    end

module type Donortype =

    sig 
        val donortype : Human.donortype
        val accepted : Human.organ_transplant_type list
        val transferring : Human.organ_transplant_type
        val waitlist_number : int32
        val id : Uuidm.t
        val cases : Human.organ_transplant_type list
    end

    module Donor(TRANSFERRING: Donortype) :
    
    sig

        type version = string

        type t = Human.donortype

        val transferring : Human.organ_transplant_type list

        val version : string

        val t : Human.donortype

    end

module Matching : sig

    type version = string

    type t = 
    {
        compatibility : bool;
        crossmatch_hla_compatibility : bool;
        illness_compatibility : bool;
        rule_compatibility : bool;
        will_survive_travel : bool;
        correct_size : bool;
        tags: (string, string) Hashtbl.t;
    }

    val version : string

    val create : Human.donortype * Human.organ_transplant_type * Human.t -> t

end
