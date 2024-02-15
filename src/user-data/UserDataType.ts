import {Unit} from "js-ballistics";

interface UserUnits {
    distance: Unit,
    velocity: Unit,
    angular: Unit,
    sizes: Unit,
    weight: Unit,
    temperature: Unit,
    pressure: Unit,
    energy: Unit,
    adjustment: Unit,
}

interface UserProfile {

}

export interface UserData {
    language: string,
    theme: "Dark"|"Light",
    units: UserUnits,
    profiles: UserProfile[]
}
