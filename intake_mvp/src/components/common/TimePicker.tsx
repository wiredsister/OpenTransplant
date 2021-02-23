type Props = {
  id: string;
  onChange: (time: string) => void;
  value?: string;
  label: string;
};

const formatTime = (value: string) => {
  if (value.length < 3) return value;
  return value.slice(0, 2) + ":" + value.slice(2, 4);
};

export const TimeInput: React.FC<Props> = ({ id, value, onChange, label }) => {
  return (
    <>
      <label
        className="block uppercase text-gray-700 text-xs font-bold mb-2"
        htmlFor={id}
      >
        {label}
      </label>
      <input
        id={id}
        className="px-3 py-3 placeholder-gray-400 text-gray-700 bg-white rounded text-sm shadow focus:outline-none focus:shadow-outline w-full"
        style={{ transition: "all .15s ease" }}
        value={value ? formatTime(value) : ""}
        onChange={(e) => {
          const value = e.target.value.replace(/:/g, "");
          if (value !== "" && isNaN(parseInt(value))) return;
          onChange(value);
        }}
        placeholder="00:00"
      ></input>
    </>
  );
};
