import { Footer } from "../Footer";
import { Navbar } from "../Navbar";

export const Layout: React.FC = ({ children }) => {
  return (
    <>
      <Navbar transparent />
      <main>
        <div
          className="relative pt-10 pb-2 flex content-center items-center justify-center"
          style={{
            minHeight: "25vh",
            borderTop: "10px solid #333",
          }}
        >
          <div
            className="absolute top-0 w-full h-full bg-center bg-cover"
            style={{
              backgroundImage:
                "url('https://images.unsplash.com/photo-1550831106-f8d5b6f1abe9?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80')",
            }}
          >
            <span
              id="blackOverlay"
              className="w-full h-full absolute opacity-90 bg-primary"
            ></span>
          </div>
          <div
            className="top-auto bottom--0 left-0 right-0 w-full absolute pointer-events-none overflow-hidden"
            style={{ height: "70px", transform: "translateZ(0)" }}
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
                className="text-white fill-current"
                points="2560 50 2560 100 0 100"
              ></polygon>
            </svg>
          </div>
        </div>
        {children}
      </main>
      <Footer />
    </>
  );
};
