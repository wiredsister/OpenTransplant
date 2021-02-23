import { SelectOption } from "./components/common/Select";
import { RadioOption } from "./components/common/RadioGroup";
import { CheckboxOption } from "./components/common/CheckboxGroup";

export type OrganType =
  | "heart"
  | "heartandlungs"
  | "rightlung"
  | "leftlung"
  | "lungs"
  | "kidneys"
  | "rightkidney"
  | "leftkidney"
  | "pancreas"
  | "liver"
  | "intestines";

export type BloodType =
  | "aneg"
  | "apos"
  | "bneg"
  | "bpos"
  | "oneg"
  | "opos"
  | "abneg"
  | "abpos";

export type BodyType =
  | "infant"
  | "toddler"
  | "child"
  | "smallmale"
  | "smallfemale"
  | "averagemale"
  | "averagefemale"
  | "largemale"
  | "largefemale";

export type YesOrNo = "yes" | "no";

export const organTypes: CheckboxOption<OrganType>[] = [
  { value: "heart", text: "Heart" },
  { value: "heartandlungs", text: "Heart and Lungs" },
  { value: "rightlung", text: "Lateral Right Lung" },
  { value: "leftlung", text: "Lateral Left Lung" },
  { value: "lungs", text: "Bilateral Lungs" },
  { value: "kidneys", text: "Dual Kidneys" },
  { value: "rightkidney", text: "Right Kidney" },
  { value: "leftkidney", text: "Left Kidney" },
  { value: "pancreas", text: "Pancreas" },
  { value: "liver", text: "Liver" },
  { value: "intestines", text: "Intestines" },
];

export const bloodTypes: SelectOption<BloodType>[] = [
  { value: "aneg", text: "A Negative" },
  { value: "apos", text: "A Positive" },
  { value: "bneg", text: "B Negative" },
  { value: "bpos", text: "B Positive" },
  { value: "oneg", text: "O Negative" },
  { value: "opos", text: "O Positive" },
  { value: "abneg", text: "AB Negative" },
  { value: "abpos", text: "AB Positive" },
];

export const bodyTypes: SelectOption<BodyType>[] = [
  { value: "infant", text: "Infant" },
  { value: "toddler", text: "Toddler" },
  { value: "child", text: "Child" },
  { value: "smallmale", text: "Small Male" },
  { value: "smallfemale", text: "Small Female" },
  { value: "averagemale", text: "Average Male" },
  { value: "averagefemale", text: "Average Female" },
  { value: "largemale", text: "Large Male" },
  { value: "largefemale", text: "Large Female" },
];

export const yesNoOptions: RadioOption<YesOrNo>[] = [
  { value: "yes", text: "Yes" },
  { value: "no", text: "No" },
];
