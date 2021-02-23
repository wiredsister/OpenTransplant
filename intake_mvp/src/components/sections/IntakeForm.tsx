import { useCallback, useState } from "react";
import {
  faArrowRight,
  faClipboardList,
  faExclamationTriangle,
  faHeart,
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import * as yup from "yup";
import { CheckboxGroup } from "../common/CheckboxGroup";
import { DatePicker } from "../common/DatePicker";
import { Fieldset } from "../common/Fieldset";
import { FormArea } from "../common/FormArea";
import { RadioGroup } from "../common/RadioGroup";
import { Select } from "../common/Select";
import { TextInput } from "../common/TextInput";
import { TimeInput } from "../common/TimePicker";
import {
  BloodType,
  bloodTypes,
  BodyType,
  bodyTypes,
  OrganType,
  organTypes,
  yesNoOptions,
  YesOrNo,
} from "../../intakeFields";
import { Page } from "../layout/Page";

type FormData = Partial<{
  organType: OrganType[];
  bloodType: BloodType;
  bodyType: BodyType;
  extractionDate: Date;
  extrationTime: string;
  hlaClass1: string;
  hlaClass2: string;
  emailAddress: string;
  phoneNumber: string;
  dob: Date;
  readyForTransplant: YesOrNo;
  ableToBeContacted: YesOrNo;
}>;

type Errors = Partial<Record<keyof FormData, string>>;

const requiredOfValue = <A extends { value: string }[]>(arr: A) =>
  yup
    .string()
    .oneOf(arr.map(({ value }) => value))
    .required();

const schema = yup.object().shape({
  organType: yup.array().of(requiredOfValue(organTypes)).required(),
  bloodType: requiredOfValue(bloodTypes),
  bodyType: requiredOfValue(bodyTypes),
  extractionDate: yup.string().required(),
  extrationTime: yup.string().required(),
  hlaClass1: yup.string().required(),
  hlaClass2: yup.string().required(),
  emailAddress: yup.string().email().required(),
  phoneNumber: yup
    .string()
    .matches(/^\d{10}$/, "Phone number is not valid")
    .required(),
  dob: yup.string().required(),
  readyForTransplant: requiredOfValue(yesNoOptions),
  ableToBeContacted: requiredOfValue(yesNoOptions),
});

export const IntakeForm: React.FC = () => {
  const [formData, setFormData] = useState<FormData>({});
  const [errors, setErrors] = useState<Errors>({});

  const setFormField = useCallback(
    <K extends keyof FormData>(key: K) => (value: FormData[K]) => {
      setFormData((formData) => ({ ...formData, [key]: value }));
    },
    []
  );

  const runValidations = useCallback(async () => {
    try {
      const results = await schema.validate(formData, {
        abortEarly: false,
      });
      setErrors({});
      return results;
    } catch (err) {
      const errors = (err as yup.ValidationError).inner.reduce((acc, el) => {
        const key = el.path as keyof Errors;
        acc[key] = el.message;
        return acc;
      }, {} as Errors);
      setErrors(errors);
    }
  }, [formData]);

  return (
    <Page title="Organ Intake Form">
      <form
        onSubmit={async (e) => {
          e.preventDefault();
          const valid = await runValidations();
        }}
        onBlur={(e) => {
          console.log(e.target.name);
        }}
      >
        <FormArea
          icon={faClipboardList}
          title="Basic Intake Information"
          subtitle="Basic information about the donor and donor organ(s)."
        >
          <Fieldset>
            <CheckboxGroup
              id="organ-type"
              checkboxes={organTypes}
              onChange={setFormField("organType")}
              label="Organ Type(s)"
              checked={formData.organType || []}
              columns={2}
            />
            <SingleFormError error={errors.organType} />
          </Fieldset>
          <Fieldset>
            <Select
              id="blood-type"
              options={bloodTypes}
              onChange={setFormField("bloodType")}
              label="Blood Type"
              selected={formData.bloodType}
            />
            <SingleFormError error={errors.bloodType} />
          </Fieldset>
          <Fieldset>
            <Select
              id="body-type"
              options={bodyTypes}
              onChange={setFormField("bodyType")}
              label="Body Type"
              selected={formData.bodyType}
            />
            <SingleFormError error={errors.bodyType} />
          </Fieldset>
          <Fieldset>
            <DatePicker
              id="extraction-date"
              label="Extraction Date"
              value={formData.extractionDate}
              onChange={setFormField("extractionDate")}
            />
            <SingleFormError error={errors.extractionDate} />
          </Fieldset>
          <Fieldset>
            <TimeInput
              id="extraction-time"
              label="Extraction Time"
              value={formData.extrationTime}
              onChange={setFormField("extrationTime")}
            />
            <SingleFormError error={errors.extrationTime} />
          </Fieldset>
          <Fieldset>
            <TextInput
              id="hla-class-1"
              label="HLA Type Information, Class I:"
              value={formData.hlaClass1 || ""}
              onChange={setFormField("hlaClass1")}
            />
            <SingleFormError error={errors.hlaClass1} />
          </Fieldset>
          <Fieldset>
            <TextInput
              id="hla-class-2"
              label="HLA Type Information, Class II:"
              value={formData.hlaClass2 || ""}
              onChange={setFormField("hlaClass2")}
            />
            <SingleFormError error={errors.hlaClass2} />
          </Fieldset>
        </FormArea>
        <FormArea
          title="Living Donor (Optional)"
          subtitle="Information about the living donor, if applicable."
          icon={faHeart}
        >
          <Fieldset>
            <TextInput
              id="email"
              label="Email Address"
              value={formData.emailAddress || ""}
              onChange={setFormField("emailAddress")}
              placeholder="name@example.com"
            />
            <SingleFormError error={errors.emailAddress} />
          </Fieldset>
          <Fieldset>
            <TextInput
              id="phone-number"
              label="Phone Number"
              value={formData.phoneNumber || ""}
              onChange={setFormField("phoneNumber")}
              placeholder={"123-456-7890"}
            />
            <SingleFormError error={errors.phoneNumber} />
          </Fieldset>
          <Fieldset>
            <DatePicker
              id="date-of-birth"
              label="Date of Birth"
              onChange={setFormField("dob")}
              value={formData.dob}
              showYearDropdown
            />
            <SingleFormError error={errors.dob} />
          </Fieldset>
          <Fieldset>
            <RadioGroup
              label="Is the donor ready for transplant?"
              options={yesNoOptions}
              id="ready-for-transplant"
              selected={formData.readyForTransplant}
              onChange={setFormField("readyForTransplant")}
            />
            <SingleFormError error={errors.readyForTransplant} />
          </Fieldset>
          <Fieldset>
            <RadioGroup
              label="Is the donor able to be contacted?"
              options={yesNoOptions}
              id="able-to-be-contacted"
              selected={formData.ableToBeContacted}
              onChange={setFormField("ableToBeContacted")}
            />
            <SingleFormError error={errors.ableToBeContacted} />
          </Fieldset>
        </FormArea>
        {Object.values(errors).length > 0 && (
          <div className="text-gray-800 bg-red-300 p-5 rounded">
            <h3 className="text-2xl">
              <FontAwesomeIcon className="mr-3" icon={faExclamationTriangle} />
              Intake Errors
            </h3>
            <p className="my-3">
              Please correct the following errors prior to submitting the form:
            </p>
            <ul className="list-disc ml-8">
              {Object.values(errors).map((e) => (
                <li className="my-1" key={e}>
                  {e}
                </li>
              ))}
            </ul>
          </div>
        )}
        <div className="text-center mt-6">
          <button
            className="bg-secondary-dark text-white active:bg-gray-700 text-lg font-bold uppercase px-6 py-3 rounded shadow hover:shadow-lg outline-none focus:outline-none mt-5 mr-1 mb-10"
            type="submit"
            style={{ transition: "all .15s ease" }}
          >
            Submit for Intake <FontAwesomeIcon icon={faArrowRight} />
          </button>
        </div>
      </form>
    </Page>
  );
};

const SingleFormError: React.FC<{ error: string | undefined }> = ({
  error,
}) => {
  return error ? (
    <div className="text-gray-800 bg-red-300 p-5 rounded">
      <p>
        <FontAwesomeIcon className="mr-3" icon={faExclamationTriangle} />
        {error}
      </p>
    </div>
  ) : (
    <></>
  );
};
