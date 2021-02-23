export type CheckboxOption<T> = {
  value: T;
  text: string;
};

type Props<T> = {
  checkboxes: CheckboxOption<T>[];
  label: string;
  id: string;
  onChange: (allChecked: T[]) => void;
  checked: T[];
  columns?: number;
};

export const CheckboxGroup = <T extends string>({
  checkboxes,
  label,
  id,
  onChange,
  checked,
  columns = 2,
}: Props<T>) => {
  const isChecked = (value: T) => checked.includes(value);

  const itemsPerColumn = Math.ceil(checkboxes.length / columns);

  const groups = new Array(itemsPerColumn)
    .fill("")
    .map((_, i) =>
      checkboxes.slice(i * itemsPerColumn, (i + 1) * itemsPerColumn)
    );

  return (
    <>
      <legend className="block uppercase text-gray-700 text-xs font-bold mb-2">
        {label}
      </legend>
      <div className={`grid md:grid-cols-${columns}`}>
        {groups.map((checkboxes, i) => {
          return (
            <div key={i}>
              {checkboxes.map((checkbox) => (
                <label key={checkbox.value} className="block h-9">
                  <input
                    type="checkbox"
                    name={id}
                    value={checkbox.value}
                    checked={isChecked(checkbox.value)}
                    onChange={(e) => {
                      const selected = e.target.value as T;
                      let newChecked = checked.includes(selected)
                        ? checked.filter((el) => el !== selected)
                        : [...checked, selected];
                      onChange(newChecked);
                    }}
                  />{" "}
                  {checkbox.text}
                </label>
              ))}
            </div>
          );
        })}
      </div>
    </>
  );
};
