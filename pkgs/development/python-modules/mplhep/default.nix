{ lib
, buildPythonPackage
, fetchPypi
, hist
, matplotlib
, mplhep-data
, pytestCheckHook
, pytest-mock
, pytest-mpl
, scipy
, setuptools
, setuptools-scm
, uhi
, uproot
}:

buildPythonPackage rec {
  pname = "mplhep";
  version = "0.3.34";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-B7pCC3n5b/cDBRDcg+p53RTad8N8iwqsLyxFA4Pm5fM=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    matplotlib
    uhi
    mplhep-data
  ];

  nativeCheckInputs = [
    hist
    pytestCheckHook
    pytest-mock
    pytest-mpl
    scipy
    uproot
  ];

  disabledTests = [
    # requires uproot4
    "test_inputs_uproot"
    "test_uproot_versions"
  ];

  pythonImportsCheck = [
    "mplhep"
  ];

  meta = with lib; {
    description = "Extended histogram plots on top of matplotlib and HEP compatible styling similar to current collaboration requirements (ROOT)";
    homepage = "https://github.com/scikit-hep/mplhep";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
