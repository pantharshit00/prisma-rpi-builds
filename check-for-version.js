const axios = require("axios");
const path = require("path");
const { readFile } = require("fs/promises");

const getStoredVersion = async () => {
  const version = await readFile(path.join(__dirname, "version"));
  return version.toString().trim();
};

async function main() {
  const releaseUrl =
    "https://api.github.com/repos/prisma/prisma/releases/latest";

  const { data: releaseData } = await axios.get(releaseUrl);

  const releaseName = releaseData.name;

  const storedVersion = await getStoredVersion();

  if (releaseName !== storedVersion) {
    console.log(`New version of Prisma available: ${releaseName}`);
    console.log(`::set-output name=new_prisma_version::${releaseName}`);
  }
}

main();
