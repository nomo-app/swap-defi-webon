const nomoCliConfig = {
  deployTargets: {
    production: {
      rawSSH: {
        sshHost: process.env.SSH_TARGET,
        sshBaseDir: "/var/www/production_webons/swapdefi/",
        publicBaseUrl: "https://w.nomo.app/swapdefi",
        hybrid: true,
      },
    },
  },
};

module.exports = nomoCliConfig;
