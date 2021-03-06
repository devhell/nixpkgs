{ stdenv
, lib
, buildPythonApplication
, fetchFromGitHub
, dateutil
, pandas
, requests
, lxml
, openpyxl
, xlrd
, h5py
, psycopg2
, pyshp
, fonttools
, pyyaml
, pdfminer
, vobject
, tabulate
, wcwidth
, zstandard
, setuptools
, git
, withPcap ? true, dpkt, dnslib
}:
buildPythonApplication rec {
  pname = "visidata";
  version = "2.4";

  src = fetchFromGitHub {
    owner = "saulpw";
    repo = "visidata";
    rev = "v${version}";
    sha256 = "0mvf2603d9b0s6rh7sl7mg4ipbh0nk05xgh1078mwvx31qjsmq1i";
  };

  propagatedBuildInputs = [
    # from visidata/requirements.txt
    # packages not (yet) present in nixpkgs are commented
    dateutil
    pandas
    requests
    lxml
    openpyxl
    xlrd
    h5py
    psycopg2
    pyshp
    #mapbox-vector-tile
    #pypng
    fonttools
    #sas7bdat
    #xport
    #savReaderWriter
    pyyaml
    #namestand
    #datapackage
    pdfminer
    #tabula
    vobject
    tabulate
    wcwidth
    zstandard
    setuptools
  ] ++ lib.optionals withPcap [ dpkt dnslib ];

  checkInputs = [
    git
  ];

  # check phase uses the output bin, which is not possible when cross-compiling
  doCheck = stdenv.buildPlatform == stdenv.hostPlatform;

  checkPhase = ''
    # disable some tests which require access to the network
    rm tests/load-http.vd            # http
    rm tests/graph-cursor-nosave.vd  # http
    rm tests/messenger-nosave.vd     # dns

    # disable some tests which expect Python == 3.6 (not our current version)
    # see https://github.com/saulpw/visidata/issues/1014
    rm tests/describe.vd
    rm tests/describe-error.vd
    rm tests/edit-type.vd

    # tests use git to compare outputs to references
    git init -b "test-reference"
    git config user.name "nobody"; git config user.email "no@where"
    git add .; git commit -m "test reference"

    substituteInPlace dev/test.sh --replace "bin/vd" "$out/bin/vd"
    bash dev/test.sh
  '';

  meta = {
    inherit version;
    description = "Interactive terminal multitool for tabular data";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.raskin ];
    homepage = "http://visidata.org/";
    changelog = "https://github.com/saulpw/visidata/blob/v${version}/CHANGELOG.md";
  };
}
