open CalendarLib
open Uuidm

module Algorithm = struct 

    let version = "Alpha.0.0.1"

end

module OPO = struct 

    type t =
    | ALCH_TX1
    | ALUA_TX1
    | ALVA_TX1
    | ARBH_TX1
    | ARCH_TX1
    | ARUA_TX1
    | AZCH_TX1
    | AZGS_TX1
    | AZMC_TX1
    | AZSJ_TX1
    | AZUA_TX1
    | CACH_TX1
    | CACL_TX1
    | CACS_TX1
    | CAGH_TX1
    | CAIM_TX1
    | CALA_TX1
    | CALL_TX1
    | CAMB_TX1
    | CAPC_TX1
    | CAPM_TX1
    | CASD_TX1
    | CASF_TX1
    | CASG_TX1
    | CASH_TX1
    | CASJ_TX1
    | CASM_TX1
    | CASU_TX1
    | CASV_TX1
    | CAUC_TX1
    | CAUH_TX1
    | COCH_TX1
    | COSL_TX1
    | COUC_TX1
    | CTHH_TX1
    | CTYN_TX1
    | DCCH_TX1
    | DCGU_TX1
    | DCGW_TX1
    | DCWH_TX1
    | DCWR_TX1
    | DEAI_TX1
    | DECC_TX1
    | FLBC_TX1
    | FLCC_TX1
    | FLFH_TX1
    | FLHM_TX1
    | FLJM_TX1
    | FLLM_TX1
    | FLMR_TX1
    | FLSH_TX1
    | FLSL_TX1
    | FLTG_TX1
    | FLUF_TX1
    | GAEH_TX1
    | GAEM_TX1
    | GAMC_TX1
    | GAPH_TX1
    | HIQM_TX1
    | IAIM_TX1
    | IAIV_TX1
    | IAMH_TX1
    | IAVA_TX1
    | ILCH_TX1
    | ILCM_TX1
    | ILLU_TX1
    | ILMM_TX1
    | ILNM_TX1
    | ILPL_TX1
    | ILSF_TX1
    | ILUC_TX1
    | ILUI_TX1
    | INIM_TX1
    | INLH_TX1
    | INSV_TX1
    | KSUK_TX1
    | KYJH_TX1
    | KYKC_TX1
    | KYUK_TX1
    | LACH_TX1
    | LAOF_TX1
    | LATU_TX1
    | LAWK_TX1
    | MABI_TX1
    | MABS_TX1
    | MABU_TX1
    | MACH_TX1
    | MALC_TX1
    | MAMG_TX1
    | MANM_TX1
    | MAPB_TX1
    | MAUM_TX1
    | MDJH_TX1
    | MDUM_TX1
    | MEMC_TX1
    | MIBH_TX1
    | MICH_TX1
    | MIDV_TX1
    | MIHF_TX1
    | MIHH_TX1
    | MISH_TX1
    | MISJ_TX1
    | MISM_TX1
    | MIUM_TX1
    | MNAN_TX1
    | MNCM_TX1
    | MNHC_TX1
    | MNMC_TX1
    | MNUM_TX1
    | MOBH_TX1
    | MOCG_TX1
    | MOCH_TX1
    | MOCM_TX1
    | MOLH_TX1
    | MORH_TX1
    | MOSL_TX1
    | MOUM_TX1
    | MSUM_TX1
    | NCBG_TX1
    | NCCM_TX1
    | NCDU_TX1
    | NCEC_TX1
    | NCMH_TX1
    | NDMC_TX1
    | NDSL_TX1
    | NEUN_TX1
    | NHDH_TX1
    | NJBI_TX1
    | NJHK_TX1
    | NJLL_TX1
    | NJRW_TX1
    | NJSB_TX1
    | NJUH_TX1
    | NMAQ_TX1
    | NMPH_TX1
    | NVUM_TX1
    | NYAM_TX1
    | NYCC_TX1
    | NYCP_TX1
    | NYDS_TX1
    | NYEC_TX1
    | NYFL_TX1
    | NYMA_TX1
    | NYMS_TX1
    | NYNS_TX1
    | NYNY_TX1
    | NYSB_TX1
    | NYUC_TX1
    | NYUM_TX1
    | NYWC_TX1
    | OHCC_TX1
    | OHCH_TX1
    | OHCM_TX1
    | OHCO_TX1
    | OHOU_TX1
    | OHTC_TX1
    | OHUC_TX1
    | OHUH_TX1
    | OKBC_TX1
    | OKMD_TX1
    | OKSF_TX1
    | OKSJ_TX1
    | ORGS_TX1
    | ORUO_TX1
    | ORVA_TX1
    | PAAE_TX1
    | PAAG_TX1
    | PACC_TX1
    | PACH_TX1
    | PACP_TX1
    | PAGM_TX1
    | PAHE_TX1
    | PAHH_TX1
    | PAHM_TX1
    | PALH_TX1
    | PALV_TX1
    | PAPH_TX1
    | PAPT_TX1
    | PASC_TX1
    | PATJ_TX1
    | PATU_TX1
    | PAUP_TX1
    | PAVA_TX1
    | PRCC_TX1
    | PRSJ_TX1
    | RIRH_TX1
    | SCMU_TX1
    | SDMK_TX1
    | SDSV_TX1
    | TNBM_TX1
    | TNEM_TX1
    | TNLB_TX1
    | TNMH_TX1
    | TNPV_TX1
    | TNST_TX1
    | TNUK_TX1
    | TNVA_TX1
    | TNVU_TX1
    | TXAS_TX1
    | TXBC_TX1
    | TXCF_TX1
    | TXCM_TX1
    | TXCT_TX1
    | TXDC_TX1
    | TXDM_TX1
    | TXDR_TX1
    | TXFW_TX1
    | TXHD_TX1
    | TXHH_TX1
    | TXHI_TX1
    | TXHS_TX1
    | TXJS_TX1
    | TXLP_TX1
    | TXMC_TX1
    | TXMH_TX1
    | TXPL_TX1
    | TXPM_TX1
    | TXSP_TX1
    | TXSW_TX1
    | TXTC_TX1
    | TXTX_TX1
    | TXUC_TX1
    | TXVA_TX1
    | UTLD_TX1
    | UTMC_TX1
    | UTPC_TX1
    | VACH_TX1
    | VAFH_TX1
    | VAHD_TX1
    | VAMC_TX1
    | VANG_TX1
    | VAUV_TX1
    | VTMC_TX1
    | WACH_TX1
    | WASH_TX1
    | WASM_TX1
    | WAUW_TX1
    | WAVM_TX1
    | WICH_TX1
    | WISE_TX1
    | WISL_TX1
    | WIUW_TX1
    | WVCA_TX1
    
end

module Human = struct

    type t =
    {
        details: details;
        blood_type: blood_type;
        body_size: body_size;
        hla_class_I: hla_class_I;
        hla_class_II: hla_class_II;
        (* Dictionary: Key:ICD10_CODE, Value:TEST_RESULT *)
        prognosis_tags: (disease, bool option) Hashtbl.t
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

    (* let is_child (patient:t) : bool =
        match patient.details.birthdate with *)


    let has_disease (patient:t) (disease:disease) : bool = begin
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
        | Heart 
        | Lung of sidededness
        | Liver 
        | Kidney of sidededness
        | Pancreas
        | Intestines

    and sidededness = Right | Left

end

module type PatientOrganToBeReplaced = sig val organ_to_replace : Organ.t end

module Patient(O: PatientOrganToBeReplaced) = struct 

    type t = Human.t * info
    and vitals = {
        (** 
        Mg/dL, or milligrams per deciliter, is a measurement that indicates 
        the amount of a particular substance (such as glucose) in a specific 
        amount of blood.

        Source: https://www.webmd.com/diabetes/qa/what-does-mgdl-mean *)
        bilirubin: mg * dL;

        (** 
        An equivalent is the amount of a substance that will react with a certain number 
        of hydrogen ions. A milliequivalent is one-thousandth of an equivalent.

        Source: https://hartfordhospital.org/health-wellness/health-resources/health-library/detail?id=stm159429&lang=en-us *)
        serum_sodium: mEq * l;


    }

    (** Milligrams fluid volume *)
    and mg = float

    (** Decilitre *)
    and dL = float

    (** A milliequivalent is one-thousandth of an equivalent *)
    and mEq = float

    (** Liter fluid volume *)
    and l = float

    (** 
        CCVHD = Continuous Veno-Venous Hemodialysis
        SCT = Serum Creatine Test *)
    and 
    has_had_CVVHD_for_24H_a_week_prior_to_SCT = bool

    (** 
        CCVHD = Continuous Veno-Venous Hemodialysis
        SCT = Serum Creatine Test *)
    and has_had_dialysis_twice_a_week_prior_to_SCT = bool

    (** 
        The International Normalized Ratio of Prothrombin Time *)
    and inr = float
    and info = { 
        
        zipcode: Human.zipcode;
        body_size: Human.body_size;
        vitals: vitals;
        identification: Uuidm.t;
    }

    (** https://optn.transplant.hrsa.gov/resources/allocation-calculators/meld-calculator/ *)
    
    (* let is_healthy =
        match O.organ_to_replace with
        | Heart _ -> ()
        | Lung _ -> ()
        | Pancreas _ -> ()
        | _ -> () *)

end

type donortype = LivingDonor of Human.t * Organ.t | RegularDonor of Organ.t

module type DonorType = sig val donortype : donortype end

module Donor (DT: DonorType) = struct 

end 

module type OrganTransplantType = sig val body_part : Organ.t end

module Scores(O: OrganTransplantType) = struct 


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

end

module Transplants = struct 

    let heart = `v5(Organ.Heart, Printf.sprintf "Heart Transplant %s" Algorithm.version)

    (** 
        Lung Transplant Workflows
        Source: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4247525/ *)
    let right_lung () = `v5(Organ.Lung (Right), Printf.sprintf "Right Lung Transplant %s" Algorithm.version)
    let left_lung () = `v5(Organ.Lung (Left), Printf.sprintf "Left Lung Transplant %s" Algorithm.version)
    
    let bilateral_lung = 
        let left = left_lung() in
        let right = right_lung() in
        left,right

    let right_kidney = 
        `v5(Organ.Kidney (Right), Printf.sprintf "Right Kidney Transplant %s" Algorithm.version)
    let left_kidney = 
        `v5(Organ.Kidney (Left), Printf.sprintf "Left Kidney Transplant %s" Algorithm.version)

(* 
    module Heart = struct
        
        let body_part = 
            let uuid = v5 Heart  (Printf.sprintf "Heart Transplant: Algo V %s" Algorithm.version) 
       

    end *)

end
