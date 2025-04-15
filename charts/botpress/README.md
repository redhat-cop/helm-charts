# Deploy Botpress Server Community Helm Charts on Red Hat OpenShift
<link rel="icon" href="https://raw.githubusercontent.com/maximilianoPizarro/botpress-helm-chart/main/favicon-152.ico" type="image/x-icon" >
<p align="left">
<img src="https://img.shields.io/badge/redhat-CC0000?style=for-the-badge&logo=redhat&logoColor=white" alt="Redhat">
<img src="https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white" alt="kubernetes">
<img src="https://img.shields.io/badge/helm-0db7ed?style=for-the-badge&logo=helm&logoColor=white" alt="Helm">
<img src="https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white" alt="shell">
<a href="https://www.linkedin.com/in/maximiliano-gregorio-pizarro-consultor-it"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="linkedin" /></a>
<a href="https://artifacthub.io/packages/search?repo=botpress"><img src="https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/botpress" alt="Artifact Hub" /></a>
</p>

[![Open](https://img.shields.io/static/v1?label=Open%20in&message=Developer%20Sandbox&logo=eclipseche&color=FDB940&labelColor=525C86)](https://workspaces.openshift.com/#https://github.com/maximilianoPizarro/botpress-helm-chart/tree/main?storageType=ephemeral)

<p align="left">
  <img src="https://raw.githubusercontent.com/maximilianoPizarro/botpress-helm-chart/main/botpress-helm.png" width="900" title="Run On Openshift">
  <img src="https://raw.githubusercontent.com/maximilianoPizarro/botpress-server-v12/master/examples/image/botpress-helm.PNG" width="900" title="Run On Openshift">
    <img src="https://raw.githubusercontent.com/maximilianoPizarro/botpress-server-v12/master/examples/image/botpress-helm-install.PNG" width="900" title="Run On Openshift">
  <img src="https://raw.githubusercontent.com/maximilianoPizarro/botpress-server-v12/master/examples/image/botpress-helm-install-devcatalog.PNG" width="900" title="Run On Openshift">
  <img src="https://raw.githubusercontent.com/maximilianoPizarro/botpress-server-v12/master/examples/image/botpress-helm-install-devcatalog-2.PNG" width="900" title="Run On Openshift">
</p>
<p align="left">
  <img src="https://github.com/maximilianoPizarro/botpress-server-v12/blob/master/examples/image/Captura7.PNG?raw=true" width="900" title="Run On Openshift">
  <img src="https://github.com/maximilianoPizarro/botpress-server-v12/blob/master/examples/image/Captura8.PNG?raw=true" width="900" title="Run On Openshift">
</p>

<p align="left">
The purpose of this project is to generate the kubernetes objects based on the node image from the official repository <a href="https://botpress.com">botpress</a> for deployment on container platforms using the Helm Charts strategy. Verified in <a href="https://developers.redhat.com/developer-sandbox">Sandbox RedHat OpenShift Dedicated</a> (Openshift 4.14.1).
</p>

# Installation

## Charts Values Parameters

| Parameter                     | Value                                   | Default                        |
|-----------------------------|-----------------------------------------------------|------------------------------------|
| env.EXTERNAL_URL              | https://my-botpress-NAMESPACE-dev.apps.sandbox-m2.ll9k.p1.openshiftapps.com                                               | https://botpress-server-maximilianopizarro5-dev.apps.sandbox-m2.ll9k.p1.openshiftapps.com               |
| image.repository        | botpress/server                                               | quay.io/maximilianopizarro/botpress-server-v12         |


## Add repository

```bash
helm repo add botpress https://redhat-cop.github.io/helm-charts
```

## Install Chart with parameters

```bash
helm install botpress botpress/botpress --version VERSION --set env.EXTERNAL_URL="Your-WilcardDNS-with-https"
```

```bash
Example:
helm install botpress botpress/botpress --version 0.1.1 --set env.EXTERNAL_URL="https://my-botpress-maximilianopizarro5-dev.apps.sandbox-m2.ll9k.p1.openshiftapps.com"
```


## Uninstall Chart

```bash
helm uninstall botpress
```


## What is Botpress?

Botpress is the standard developer stack to build, run, and improve conversational AI applications. Powered by natural language understanding, a messaging API, and a fully featured studio, Botpress allows developers and conversation designers around the globe to build remarkable chatbots without compromise.

The fastest & easiest way to get started with Botpress is by signing up for free to **[Botpress Cloud](https://sso.botpress.cloud/registration)**. Alternatively, continue reading for more information about Botpress v12.


**Out of the box, Botpress v12 includes:**

- Administration panel to orchestrate and monitor your chatbots
- Conversation Studio to design a conversation, manage content, code custom integration
- Easy integration with messaging channels (Messenger, WhatsApp, Slack, Teams, Webchat, Telegram, SMS & more)
- Natural Language Understanding
- Complete list of features and specs [here](https://v12.botpress.com/overview/features)

## Getting Started

There are a few ways to get started with Botpress v12:

- Download the latest binary for your OS [here](https://v12.botpress.com/) and follow the [installation docs](https://v12.botpress.com/overview/quickstart/installation).
- Use the official [Docker image](https://hub.docker.com/r/botpress/server) and follow the [hosting docs](https://v12.botpress.com/going-to-production/deploy/docker-compose)
- Run from sources, follow [build docs](https://v12.botpress.com/going-to-production/deploy/)


## Documentation

- [Main Documentation](https://v12.botpress.com/)
- [SDK Reference](https://botpress.com/reference/)
- [Code Examples](https://github.com/botpress/v12/tree/master/examples)
- [Video Tutorials](https://www.youtube.com/c/botpress)



## Community

- [Discord](https://discord.gg/botpress) - Get community support and find answers to your questions
- [Issues](https://github.com/botpress/v12/issues) - Report bugs and file feature requests
- [Blog](https://botpress.com/blog) - How to's, case studies, and announcements
- [Contributing](/.github/CONTRIBUTING.md) - Start contributing to Botpress
- [Partners](/.github/PARTNERS.md) - List of agencies who can help you with Botpress

## License

Botpress is dual-licensed under [AGPLv3](/licenses/LICENSE_AGPL3) and the [Botpress Proprietary License](/licenses/LICENSE_BOTPRESS).

By default, any bot created with Botpress is licensed under AGPLv3, but you may change to the Botpress License from within your bot's web interface in a few clicks.

For more information about how the dual-license works and why it works that way, please see the <a href="https://botpress.com/faq">FAQS</a>.

![](https://api.segment.io/v1/pixel/page?data=eyJ3cml0ZUtleSI6InczR0xQaGFwY1RqTjdZVnJZQVFYU05Wam9yVUFNOXBmIiwidXNlcklkIjoiYW5vbnltb3VzIn0=)
