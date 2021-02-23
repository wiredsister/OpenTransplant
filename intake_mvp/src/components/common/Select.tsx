export type SelectOption<T> = {
  value: T;
  text: string;
};

type Props<T> = {
  options: SelectOption<T>[];
  id: string;
  label: string;
  onChange: (selected: T) => void;
  selected?: T;
};

export const Select = <T extends string>({
  id,
  label,
  onChange,
  options,
  selected,
}: Props<T>) => {
  return (
    <>
      <label
        className="block uppercase text-gray-700 text-xs font-bold mb-2"
        htmlFor={id}
      >
        {label}
      </label>
      <select
        id={id}
        className="px-3 py-3 placeholder-gray-400 text-gray-700 bg-white rounded text-sm shadow focus:outline-none focus:shadow-outline w-full"
        style={{ transition: "all .15s ease" }}
        value={selected || ""}
        onChange={(e) => {
          const selected = e.target.value as T;
          onChange(selected);
        }}
      >
        <option hidden disabled value="">
          -- select an option --
        </option>
        {options.map((option) => (
          <option key={option.value} value={option.value}>
            {option.text}
          </option>
        ))}
      </select>
    </>
  );
};
