{ lib
, fetchFromGitHub
, buildPythonPackage
, deprecation
, docker
, wrapt }:

buildPythonPackage rec {
  pname = "testcontainers";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "testcontainers";
    repo = "testcontainers-python";
    rev = "v${version}";
    sha256 = "sha256-t6W5A877bSPcbKVzCLEhjPzOPwF8ZTGjlvnwt1CwWCE=";
  };

  buildInputs = [
    deprecation
    docker
    wrapt
  ];

  # Tests require various container and database services running
  doCheck = false;

  pythonImportsCheck = [
    "testcontainers"
  ];

  meta = with lib; {
    description = ''
      Allows using docker containers for functional and integration testing
    '';
    homepage = "https://github.com/testcontainers/testcontainers-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
