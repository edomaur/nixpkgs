{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
, testers
, cloudquery
}:

buildGoModule rec {
  pname = "cloudquery";
  version = "3.8.0";

  excludedPackages = "test";

  subPackages = [ "cmd/cloudquery" ];

  src = fetchFromGitHub {
    owner = "cloudquery";
    repo = "cloudquery";
    rev = "v${version}";  # ? cloudquery is in fact "cloudquery-cli", plugins must not be built.
    sha256 = "sha256-P0E5/sFvrO58SG94cGatRFPWMwrBBrvxdckc0mUaFPE=";
  };

  vendorHash = "sha256-n6tPCVormgNEDcUmDXmpiFjJQXgAccGtCFT1GHwOdV4=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/cloudquery/cloudquery/internal.Commit=${src.rev}"
    "-X=github.com/cloudquery/cloudquery/internal.Version=${version}"
  ];

  passthru.tests = {
    inherit (nixosTests) cloudquery;
    version = testers.testVersion {
      package = cloudquery;
    };
  };

  meta = with lib; {
    description = "The plugin-driven server agent for collecting & reporting metrics";
    homepage = "https://www.cloudquery.io";
    changelog = "https://github.com/cloudquery/cloudquery/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ edomaur ];
  };
}
