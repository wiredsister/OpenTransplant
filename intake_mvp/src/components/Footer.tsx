import logo from "../img/logo.svg";

export const Footer = () => {
  return (
    <>
      <footer className="relative bg-secondary pt-16 pb-6">
        <div
          className="bottom-auto top--0 left-0 right-0 w-full absolute pointer-events-none overflow-hidden -mt-20"
          style={{ height: "80px", transform: "translateZ(0)" }}
        >
          <svg
            className="absolute bottom-0 overflow-hidden"
            xmlns="http://www.w3.org/2000/svg"
            preserveAspectRatio="none"
            version="1.1"
            viewBox="0 0 2560 100"
            x="0"
            y="0"
          >
            <polygon
              className="text-gray-300 fill-secondary"
              points="2560 50 2560 100 0 100"
            ></polygon>
          </svg>
        </div>
        <div className="container mx-auto px-4">
          <div className="flex flex-wrap">
            <div className="w-full lg:w-6/12 px-4">
              <img className="h-9 mt-3" src={logo} alt="OpenTransplant" />
            </div>
            <div className="w-full lg:w-6/12 px-4">
              <div className="flex flex-wrap items-top mb-6">
                <div className="w-full lg:w-4/12 px-4 ml-auto">
                  <span className="block uppercase text-secondary-dark text-md font-semibold mb-2">
                    Resources
                  </span>
                  <ul className="list-unstyled">
                    <li>
                      <a
                        className="text-secondary-dark hover:text-gray-900 font-semibold block pb-2 text-sm"
                        href="https://github.com/wiredsister/OpenTransplant"
                      >
                        License
                      </a>
                    </li>
                    <li>
                      <a
                        className="text-secondary-dark hover:text-gray-900 font-semibold block pb-2 text-sm"
                        href="https://github.com/wiredsister/OpenTransplant"
                      >
                        GitHub
                      </a>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
          <hr className="my-6 border-secondary-light" />
          <div className="flex flex-wrap items-center md:justify-between justify-center">
            <div className="w-full md:w-4/12 px-4 mx-auto text-center">
              <div className="text-sm text-secondary-dark font-semibold py-1 uppercase">
                Organ Intake - Alpha Version 0.0.1
              </div>
            </div>
          </div>
        </div>
      </footer>
    </>
  );
};
