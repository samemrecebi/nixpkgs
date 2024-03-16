{ lib
, buildPythonPackage
, fetchFromGitHub
, garth
, pdm-backend
, pythonOlder
, requests
, withings-sync
}:

buildPythonPackage rec {
  pname = "garminconnect";
  version = "0.2.14";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "cyberjunky";
    repo = "python-garminconnect";
    rev = "refs/tags/${version}";
    hash = "sha256-FytgckIu99ZKfmxJ0KU+fpbBEgszdp8iwK3SFCL9Ejs=";
  };

  nativeBuildInputs = [
    pdm-backend
  ];

  propagatedBuildInputs = [
    garth
    requests
    withings-sync
  ];

  # Tests require a token
  doCheck = false;

  pythonImportsCheck = [
    "garminconnect"
  ];

  meta = with lib; {
    description = "Garmin Connect Python API wrapper";
    homepage = "https://github.com/cyberjunky/python-garminconnect";
    changelog = "https://github.com/cyberjunky/python-garminconnect/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
