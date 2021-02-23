type Props = {
  id: string;
  onChange: (value: string) => void;
  value: string;
  label: string;
  placeholder?: string;
};

export const TextInput: React.FC<Props> = ({
  id,
  value,
  onChange,
  label,
  placeholder,
}) => {
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
        value={value}
        onChange={(e) => {
          onChange(e.target.value);
        }}
        placeholder={placeholder}
      ></input>
    </>
  );
};
