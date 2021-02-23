import ReactDatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

type Props = {
  value?: Date;
  onChange: (date: Date) => void;
  label: string;
  id: string;
  showYearDropdown?: boolean;
};

export const DatePicker: React.FC<Props> = ({
  value,
  onChange,
  label,
  id,
  showYearDropdown = false,
}) => {
  return (
    <>
      <label
        id={id}
        className="block uppercase text-gray-700 text-xs font-bold mb-2"
      >
        {label}
      </label>
      <ReactDatePicker
        className="px-3 py-3 placeholder-gray-400 text-gray-700 bg-white rounded text-sm shadow focus:outline-none focus:shadow-outline w-full"
        ariaLabelledBy={id}
        selected={value}
        onChange={onChange}
        placeholderText="MM/DD/YYYY"
        showYearDropdown={showYearDropdown}
        dropdownMode="select"
      />
    </>
  );
};
