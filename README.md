<!-- PROJECT LOGO -->
<br />
<div align="center">
    <table>
    <tr> 
      <td align="center">
        <a href="https://enclaive.io/products/mongodb">
          <img alt="mongodb-sgx" height=64px src="https://raw.githubusercontent.com/devicons/devicon/master/icons/mongodb/mongodb-plain.svg">
        </a>
        <br>MongoDB-SGX</td>     
      </td>  
    </tr>
    </table>


  <h2 align="center">SGX-ready MongoDB: JSON Database with data-in-use Encryption</h2>

  <p align="center">
    <h3>packed by <a href="https://enclaive.io">enclaive</a></h3>
    </br>
    #intelsgx #confidentialcompute #data-sovereignty #zerotrust
    <br />
    <a href="#contributing">Contribute</a>
    ·
    <a href="https://github.com/enclaive/enclaive-docker-mongodb-sgx/issues">Report Bug</a>
    ·
    <a href="https://github.com/enclaive/enclaive-docker-mongodb-sgx/issues">Request Feature</a>
  </p>
  
<table style="width:100%">
<tr>
     <td align="center" width:"25%">
        <a href="https://www.youtube.com/watch?v=3FCULfBqFN0"><img src="https://img.youtube.com/vi/3FCULfBqFN0/0.jpg"></img></a>
        <br>MongoDB-SGX keeps the import of passwords already encrypted while in use (<a href="https://github.com/enclaive/enclaive-docker-mongodb-sgx/tree/demo">code</a>)</td> 
     </td>
 </tr>
 </table>
</div>

<!-- TL;TD --> 
## TL;DR

```sh
docker pull enclaive/mongodb-sgx
docker-compose up -d
```
**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [build](#build-the-image) section for a more secure deployment.

<!-- INTRODCUTION -->
## What is MongoDB and SGX?

MongoDB is a source-available cross-platform document-oriented database program. Classified as a NoSQL database program, MongoDB uses JSON-like documents with optional schemas. 

[Overview of MongoDB](https://www.mongodb.com/)

> Intel Security Guard Extension (SGX) delivers advanced hardware and RAM security encryption features, so called enclaves, in order to isolate code and data that are specific to each application. When data and application code run in an enclave additional security, privacy and trust guarantees are given, making the container an ideal choice for (untrusted) cloud environments.

[Overview of Intel SGX](https://www.intel.com/content/www/us/en/developer/tools/software-guard-extensions/overview.html)

Application code executing within an Intel SGX enclave:

- Remains protected even when the BIOS, VMM, OS, and drivers are compromised, implying that an attacker with full execution control over the platform can be kept at bay
- Benefits from memory protections that thwart memory bus snooping, memory tampering and “cold boot” attacks on images retained in RAM
- At no moment in time data, program code and protocol messages are leaked or de-anonymized
- Reduces the trusted computing base of its parent application to the smallest possible footprint

<!-- WHY -->
## Why use MongoDB-SGX (instead of "vanilla" MongoDB) images?
Following benefits come for free with MongoDB-SGX :

- security: MongoDB-SGX gives data the safest place a database can give going beyond database encryption ("data at rest")
- black box database: not only is the database encrypted, but also queries to the database remain fully encrypted in the memory ("data in use")
- no static table encryption needed: database running in a confidential container by design encrypts the query, query processing on data, and the database
- no key rotation needed: avoid key management and update complexities known from data-at-rest databases
- untraceability: when combined with TLS, MongoDB-SGX keeps the user interacting with the database indistinguishable from any other user interaction even
- hardened security against memory dumps, query and user de-anonymization including kernel-space exploits, malicious and accidental privilege [insider](https://www.ibm.com/topics/insider-threats) attacks, [UEFI firmware](https://thehackernews.com/2022/02/dozens-of-security-flaws-discovered-in.html) exploits and other "root" attacks using the corruption of the application to infiltrate your network and system
- runs on any hosting environment irrespectivably of geo-location and complies with privacy export regulation, such as [Schrem-II](https://www.europarl.europa.eu/RegData/etudes/ATAG/2020/652073/EPRS_ATA(2020)652073_EN.pdf)
- GDPR/CCPA compliant processing ("data in use") of user data in the cloud as data is anonymized thanks to the enclave

<!-- DEPLOY IN THE CLOUD -->
## How to deploy MongoDB-SGX in a zero-trust cloud?

The following cloud infrastractures are SGX-ready out of the box
* [Microsoft Azure Confidential Cloud](https://azure.microsoft.com/en-us/solutions/confidential-compute/) 
* [OVH Cloud](https://docs.ovh.com/ie/en/dedicated/enable-and-use-intel-sgx/)
* [Alibaba Cloud](https://www.alibabacloud.com/blog/alibaba-cloud-released-industrys-first-trusted-and-virtualized-instance-with-support-for-sgx-2-0-and-tpm_596821) 

Confidential compute is a fast growing space. Cloud providers continiously add confidential compute capabilities to their portfolio. Please [contact](#contact) us if the infrastracture provider of your preferred choice is missing.

<!-- GETTING STARTED -->
## Getting started
### Platform requirements

Check for *Intel Security Guard Extension (SGX)* presence by running the following
```
grep sgx /proc/cpuinfo
```
Alternatively have a thorough look at Intel's [processor list](https://www.intel.com/content/www/us/en/support/articles/000028173/processors.html). (We remark that macbooks with CPUs transitioned to Intel are unlikely supported. If you find a configuration, please [contact](#contact) us know.)

Note that in addition to SGX the hardware module must support FSGSBASE. FSGSBASE is an architecture extension that allows applications to directly write to the FS and GS segment registers. This allows fast switching to different threads in user applications, as well as providing an additional address register for application use. If your kernel version is 5.9 or higher, then the FSGSBASE feature is already supported and you can skip this step.

There are several options to proceed
* If: No SGX-ready hardware </br> 
[Azure Confidential Compute](https://azure.microsoft.com/en-us/solutions/confidential-compute/") cloud offers VMs with SGX support. Prices are fair and have been recently reduced to support the [developer community](https://azure.microsoft.com/en-us/updates/announcing-price-reductions-for-azure-confidential-computing/). First-time users get $200 USD [free](https://azure.microsoft.com/en-us/free/) credit. Other cloud provider like [OVH](https://docs.ovh.com/ie/en/dedicated/enable-and-use-intel-sgx/) or [Alibaba](https://www.alibabacloud.com/blog/alibaba-cloud-released-industrys-first-trusted-and-virtualized-instance-with-support-for-sgx-2-0-and-tpm_596821) cloud have similar offerings.
* Elif: Virtualization <br>
  Ubuntu 21.04 (Kernel 5.11) provides the driver off-the-shelf. Read the [release](https://ubuntu.com/blog/whats-new-in-security-for-ubuntu-21-04). Go to [download](https://ubuntu.com/download/desktop) page.
* Elif: Kernel 5.9 or higher <br>
Install the DCAP drivers from the Intel SGX [repo](https://github.com/intel/linux-sgx-driver)

  ```sh
  sudo apt update
  sudo apt -y install dkms
  wget https://download.01.org/intel-sgx/sgx-linux/2.13.3/linux/distro/ubuntu20.04-server/sgx_linux_x64_driver_1.41.bin -O sgx_linux_x64_driver.bin
  chmod +x sgx_linux_x64_driver.bin
  sudo ./sgx_linux_x64_driver.bin

  sudo apt -y install clang-10 libssl-dev gdb libsgx-enclave-common libsgx-quote-ex libprotobuf17 libsgx-dcap-ql libsgx-dcap-ql-dev az-dcap-client open-enclave
  ```

* Else: Kernel older than version 5.9 </br>
  Upgrade to Kernel 5.11 or higher. Follow the instructions [here](https://ubuntuhandbook.org/index.php/2021/02/linux-kernel-5-11released-install-ubuntu-linux-mint/).   

### Software requirements
Install the docker engine
```sh
 sudo apt-get update
 sudo apt-get install docker-ce docker-ce-cli containerd.io
 sudo usermod -aG docker $USER    # manage docker as non-root user (obsolete as of docker 19.3) 
```
Use `docker run hello-world` to check if you can run docker (without sudo).

<!-- GET THIS IMAGE -->
## Get this image

The recommended way to get the enclaive MongoDB-SGX Open Source Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/enclaive/mongodb-sgx).

```console
docker pull enclaive/mongodb-sgx:latest
```

To use a specific version, you can pull a versioned tag. You can view the
[list of available versions](https://hub.docker.com/r/enclaive/mongodb-sgx/tags/)
in the Docker Hub Registry.

```console
docker pull enclaive/mongodb-sgx:[TAG]
```
<!-- RUN THE IMAGE -->
## Run the image
Use MongoDB Compass or the MongoDB Shell to connect. No password or authentication required, this is a demo setup.

<!-- BUILD THE IMAGE -->
## Build the image
If you wish, you can also build the image yourself.

```console
docker build -t enclaive/mongodb-sgx:latest 'https://github.com/enclaive/enclaive-docker-mongodb-sgx.git#master'
```

<!-- RELEASE NOTES -->
## Release Notes

- Logfile is currently broken, see [mongod.conf](mongod.conf)
- Data persistence requires a clean shutdown, as in `db.shutdownServer()`, for the same reason as the logfile
- `HAVE_FTRUNCATE` is disabled during compilation as arbitrary sizes are not yet supported by [gramines encrypted mount](https://github.com/gramineproject/gramine/blob/master/common/src/protected_files/protected_files.c#L1219) / [permalink](https://github.com/gramineproject/gramine/blob/562c639703d56fa5d26b3bed135d31c6a843385f/common/src/protected_files/protected_files.c#L1219)
- Patch removes `flock(2)` call, as it is only used to prevent multiple instances running with the same configuration
- Another patch removes the extraction of process information from `/proc/<pid>/stat`, as it is not implemented in gramine
  - This only creates unnecessary logging of errors once a second and could be ignored

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**. If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- SUPPORT -->
## Support

Don't forget to give the project a star! Spread the word on social media! Thanks again!

<!-- LICENSE -->
## License

Distributed under the Apache License 2.0 License. See `LICENSE` for more information.

<!-- CONTACT -->
## Contact

enclaive.io - [@enclaive_io](https://twitter.com/enclaive_io) - contact@enclaive.io - [https://enclaive.io](https://enclaive.io)


<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

This project greatly celebrates all contributions from the gramine team. Special shout out to [Dmitrii Kuvaiskii](https://github.com/dimakuv) from Intel for his support. 

* [Gramine Project](https://github.com/gramineproject)
* [Intel SGX](https://github.com/intel/linux-sgx-driver)
* [MongoDB](https://www.mongodb.com/)


## Trademarks 

This software listing is packaged by enclaive.io. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement. 
