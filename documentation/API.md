


<!-- PUT : hla_test_updated -> organ_tracking_id -> Ok<tracking_id, info>, Err<>  -->

POST : organ_submission -> 
    Ok<tracking_id, barcode_sticker_to_print>, Err<user_error_reason>

type organ_transplant = 
    | Heart_And_Lungs 
    | Heart
    | BilateralLungs
    | Left_Lung
    | Right_Lung
    | Intestines
    | Liver
    | Pancreas
    | Dual_Kidney
    | Right_Kidney
    | Left_Kidney
    | Other of string

    type availability = 
    | Can_Be_Contacted_and_Transplant_Ready
    | Can_Be_Contacted_and_NOT_Transplant_Ready
    | Can_NOT_Be_Contacted_and_Transplant_Ready
    | Can_NOT_Be_Contacted_and_NOT_Transplant_Ready

{
    organ_intake_version: VERSION_STRING;
    organ_transplant_type: ALPHA_NUM_STRING;
    organ: STRING;
    intake_facility: STRING;
    intake_location: ZIPCODE_STRING;
    donor: 
        *nullable* details : {
            name : string; 
            email: string;
            primary_phone: string;
            birthdate: Date.t;
            waitlist_start: Date.t;
            availability: string e.g. "Can_Be_Contacted_and_Transplant_Ready";
        },
        *required* blood_type: blood_type e.g. "AB_Neg" "A_Pos",
        *required* body_size: body_size "Large_female",
        HLA_Class_I: string,
        HLA_Class_II: string,
        (* Dictionary: Key:ICD10_CODE, Value:TEST_RESULT *)
        icd_10_codes: JavaScript Arr, e.g. [ "P35.1" ]
    }
}

Scenario 1: 

"Given I am a user who is an OPO (Organ Procurement Organization),
And I'd like to submit a new organ via an API,
...
"

Scenario 2: 

"Given I am a user who is a Surgeon,
And I'd like to get a match for an organ on behalf of my patient,
...
"
GET : patient_match_request -> Ok<organ_match>, Err<>


