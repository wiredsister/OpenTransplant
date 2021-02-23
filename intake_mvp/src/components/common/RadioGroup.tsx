export type RadioOption<T> = {
  value: T;
  text: string;
};

type Props<T> = {
  id: string;
  options: RadioOption<T>[];
  onChange: (selected: T) => void;
  label: string;
  selected?: T;
};

export const RadioGroup = <T extends string>({
  id,
  options,
  onChange,
  label,
  selected,
}: Props<T>) => {
  return (
    <>
      <legend className="block uppercase text-gray-700 text-xs font-bold mb-2">
        {label}
      </legend>
      {options.map((option) => (
        <label key={option.value} className="mr-4">
          <input
            type="radio"
            id={id}
            value={option.value}
            onChange={(e) => {
              const selected = e.target.value as T;
              onChange(selected);
            }}
            checked={option.value === selected}
            className="mr-1"
          />
          {option.text}
        </label>
      ))}
    </>
  );
};
