type Props = {
  title: string;
};

export const Page: React.FC<Props> = ({ children, title }) => (
  <section className="relative block py-24 lg:pt-8">
    <div className="container mx-auto">
      <div className="flex flex-wrap justify-center">
        <div className="w-full lg:w-8/12">
          <div className="flex-auto lg:p-10 mb-8">
            <h1 className="text-4xl font-semibold">{title}</h1>
          </div>
        </div>
      </div>
    </div>
    <div className="container mx-auto px-4">
      <div className="flex flex-wrap justify-center">
        <div className="w-full lg:w-8/12 px-4">{children}</div>
      </div>
    </div>
  </section>
);
