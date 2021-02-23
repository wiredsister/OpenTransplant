import { IconDefinition } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

type Props = {
  title: string;
  subtitle: string;
  icon?: IconDefinition;
};

export const FormArea: React.FC<Props> = ({
  children,
  title,
  subtitle,
  icon,
}) => (
  <div className="relative flex flex-col min-w-0 break-words w-full mb-16 shadow-lg rounded-lg bg-gray-100">
    <div className="flex-auto p-5 lg:p-10">
      <div className="flex">
        {icon && (
          <FontAwesomeIcon
            className="text-5xl text-secondary-dark"
            icon={icon}
          />
        )}
        <div className={icon ? "ml-4" : undefined}>
          <h4 className="text-2xl text-gray-900 font-semibold">{title}</h4>
          <p className="leading-relaxed mt-1 mb-4 text-gray-600">{subtitle}</p>
        </div>
      </div>
      <div>{children}</div>
    </div>
  </div>
);
