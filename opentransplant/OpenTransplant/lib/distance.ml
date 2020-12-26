
open Cohttp_lwt_unix
open Lwt.Infix
open Yojson.Basic
open Yojson.Basic.Util

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

