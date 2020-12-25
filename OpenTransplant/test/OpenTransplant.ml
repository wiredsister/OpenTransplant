(* open QCheck
open CalendarLib
open OpenTransplant

module TestHelpers = struct 

  let fake_zipcodes = [| "07302"; "22206"; "32168"; "89102"; "20500" |]

  let coin_flip ?rand:(r=Random.State.make_self_init()) = 
    Gen.generate ~rand:r ~n:1 Gen.bool
    |> List.hd

  let pick_number_outta ?rand:(r=Random.State.make_self_init()) ?upto:(n=10) =
    Gen.generate ~rand:r ~n:1 @@ Gen.int_range 1 n |> List.hd

  let random_blood_type ?rand:(r=Random.State.make_self_init()) =
    let n = pick_number_outta ~rand:r ~upto:8 in
    match n with
    | 1 -> A_Pos
    | 2 -> A_Neg
    | 3 -> B_Pos
    | 4 -> B_Neg
    | 5 -> AB_Pos
    | 6 -> AB_Neg
    | 7 -> O_Pos
    | 8 -> O_Neg
    | _ -> failwith "Bad Random Seed"

  let random_vitals_type ?rand:(r=Random.State.make_self_init()) =
    let n = pick_number_outta ~rand:r ~upto:4 in
    match n with
    | 1 -> Dying
    | 2 -> Critical
    | 3 -> Stable
    | 4 -> Nominal
    | _ -> failwith "Bad Random Seed"

  let random_body_size_type ?rand:(r=Random.State.make_self_init()) =
    let n = pick_number_outta ~rand:r ~upto:9 in
    match n with
    | 1 -> Infant
    | 2 -> Toddler
    | 3 -> Child
    | 4 -> Small_Female
    | 5 -> Small_Male
    | 6 -> Average_Female
    | 7 -> Average_Male
    | 8 -> Large_Female
    | 9 -> Large_Male
    | _ -> failwith "Bad Random Seed"

    
  let random_zipcode ?rand:(r=Random.State.make_self_init()) =
    let n = pick_number_outta ~rand:r ~upto:5 in
    match n with
    | 1 -> fake_zipcodes.(0)
    | 2 -> fake_zipcodes.(1)
    | 3 -> fake_zipcodes.(2)
    | 4 -> fake_zipcodes.(3)
    | 5 -> fake_zipcodes.(4)
    | _ -> failwith "Bad Random Seed"

  let random_phone_number ?rand:(r=Random.State.make_self_init()) =    
    let first = 
      Gen.generate ~rand:r ~n:3 @@ Gen.int_range 0 9
      |> List.map string_of_int
      |> String.concat ""
    in
    let second =
      Gen.generate ~rand:r ~n:3 @@ Gen.int_range 0 9
      |> List.map string_of_int
      |> String.concat ""
    in
    let third = 

      Gen.generate ~rand:r ~n:4 @@ Gen.int_range 0 9
      |> List.map string_of_int
      |> String.concat ""
    in
    first ^ "-" ^ second ^ "-" ^ third

  let random_availability_type ?rand:(r=Random.State.make_self_init()) =
    let n = pick_number_outta ~rand:r ~upto:5 in
    match n with
    | 1 -> Can_Be_Contacted_and_Transplant_Ready
    | 2 -> Can_Be_Contacted_and_NOT_Transplant_Ready
    | 3 -> Can_NOT_Be_Contacted_and_Transplant_Ready
    | 4 -> Can_NOT_Be_Contacted_and_NOT_Transplant_Ready
    | _ -> failwith "Bad Random Seed"

  let random_prognosis_tags ?rand:(r=Random.State.make_self_init()) : (string, bool) Hashtbl.t =
    let tmp = Hashtbl.create 1 in
    let has_covid = coin_flip ~rand:r in
    if has_covid
    then begin Hashtbl.add tmp "U07.1" true; tmp end
    else tmp

  let gen_humans ?rand:(r=Random.State.make_self_init()) n =
    Gen.generate ~rand:r ~n:n Gen.string_readable
    |> List.map (fun random_string ->
      {
        blood_type = random_blood_type ~rand:r;
        vitals = random_vitals_type ~rand:r;
        zipcode = random_zipcode ~rand:r;
        body_size = random_body_size_type ~rand:r;
        prognosis_tags = random_prognosis_tags ~rand:r;
        details = {
          name = random_string ^ " " ^ random_string;
          birthdate = Date.now();
          waitlist_start = Date.now();
          primary_phone = random_phone_number ~rand:r;
          availability = random_availability_type ~rand:r;
        }
      })

end

module Test = struct 

  let ethics ?rand:(r=Random.State.make_self_init()) =
    let patient = gen_humans 1 ~rand:r |> List.hd in
    let donors = gen_humans 10 ~rand:r in
    Test.make 
      ~name:"The Algorithm Values Helping The Very Sick and Dying"
      (patient, donors)
      (fun p, ds -> true)
      

end

let tests = [
  Test.ethics
]

let test =
  QCheck_runner.run_tests_main tests

let test = () *)