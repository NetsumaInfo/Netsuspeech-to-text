const ParlerTextLogo = ({
  width,
  className,
}: {
  width?: number;
  height?: number;
  className?: string;
}) => {
  const brand = "NETSUSPEECH";
  const fontSize = width ? width / 7.8 : 22;

  return (
    <div
      className={className}
      style={{
        fontFamily: "'Geist Pixel Circle', monospace",
        fontSize,
        fontWeight: "normal",
        letterSpacing: "1px",
        lineHeight: 1.1,
        whiteSpace: "nowrap",
        width,
      }}
    >
      <span className="text-logo-primary">{brand}</span>
    </div>
  );
};

export default ParlerTextLogo;
