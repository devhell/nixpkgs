{ lib, stdenv, fetchFromGitHub, rustPlatform, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "oculante";
  version = "0.5.10";

  src = fetchFromGitHub {
    owner = "woelper";
    repo = pname;
    rev = version;
    sha256 = "0z1la2c72b8a25nzcim2i632810ffq8yx3g447p33k3ax3fggxsz";
  };

  cargoSha256 = "0mkhwzxfdlc2m3imyygp0zmfgrpidga964gmmdxvkbpagxnsqq1i";

  buildInputs = [ pkg-config ];
  nativeBuildInputs = [ openssl ];

  meta = with lib; {
    description = "A minimalistic crossplatform image viewer written in Rust";
    longDescription = ''
      An image viewer with the goal of having broad support for
      industry-standard files and gradually add more image analysis tools.
    '';
    homepage = "https://github.com/woelper/oculante";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ devhell ];
  };
}
