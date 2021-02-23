import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faBars, faHeartbeat, faUser } from "@fortawesome/free-solid-svg-icons";
import { useState } from "react";

type Props = {
  transparent: boolean;
};

const links: { href: string; text: string }[] = [
  {
    href: "/",
    text: "Organ Intake",
  },
  {
    href: "/about",
    text: "About OpenTransplant",
  },
];

export const Navbar: React.FC<Props> = (props) => {
  const [navbarOpen, setNavbarOpen] = useState(false);
  return (
    <>
      <nav
        className={
          (props.transparent
            ? "top-14 absolute z-50 w-full"
            : "relative shadow-lg bg-white shadow-lg") +
          " flex flex-wrap items-center justify-between px-2 py-1 navbar-expand-lg"
        }
      >
        <div className="container px-4 mx-auto flex flex-wrap items-center justify-between">
          <div className="w-full relative flex justify-between lg:w-auto lg:static lg:block lg:justify-start">
            <a
              className={
                (props.transparent ? "text-white" : "text-gray-800") +
                " text-xl font-bold leading-relaxed inline-block mr-4 py-3 whitespace-no-wrap uppercase"
              }
              href="/"
            >
              <FontAwesomeIcon icon={faHeartbeat} className="text-gray-200" />{" "}
              OpenTransplant
            </a>
            <button
              className="cursor-pointer text-xl leading-none px-3 py-1 border border-solid border-transparent rounded bg-transparent block lg:hidden outline-none focus:outline-none"
              type="button"
              onClick={() => setNavbarOpen(!navbarOpen)}
            >
              <FontAwesomeIcon
                className={
                  (props.transparent ? "text-white" : "text-gray-800") +
                  " fas fa-bars"
                }
                icon={faBars}
              />
            </button>
          </div>
          <div
            className={
              "lg:flex flex-grow items-center bg-white lg:bg-transparent lg:shadow-none" +
              (navbarOpen ? " block rounded shadow-lg" : " hidden")
            }
            id="example-navbar-warning"
          >
            <ul className="flex flex-col lg:flex-row list-none mr-auto">
              {links.map(({ href, text }) => (
                <li key={href} className="flex items-center">
                  <a
                    className={
                      (props.transparent
                        ? "lg:text-white lg:hover:text-gray-300 text-gray-800"
                        : "text-gray-800 hover:text-gray-600") +
                      " px-5 py-4 lg:py-2 mt-1 flex items-center text-xs uppercase font-bold"
                    }
                    href={href}
                  >
                    {text}
                  </a>
                </li>
              ))}
            </ul>
            <ul>
              <li className="flex items-center">
                <span
                  className={
                    (props.transparent
                      ? "lg:text-white text-gray-800"
                      : "text-gray-800") +
                    " py-4 lg:py-2 flex items-center text-xs font-bold"
                  }
                >
                  Cleveland Clinic (44195) | Gina
                </span>
                <button
                  className={
                    (props.transparent
                      ? "bg-white text-gray-600 active:bg-gray-100"
                      : "bg-pink-500 text-white active:bg-pink-600") +
                    " text-xs font-bold uppercase px-3 py-2 rounded-full shadow hover:shadow-md outline-none focus:outline-none lg:mr-1 lg:mb-0 ml-3 mb-3"
                  }
                  type="button"
                  style={{ transition: "all .15s ease" }}
                >
                  <FontAwesomeIcon icon={faUser} />
                </button>
              </li>
            </ul>
          </div>
        </div>
      </nav>
    </>
  );
};
