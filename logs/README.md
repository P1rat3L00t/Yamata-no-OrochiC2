# Blue Team:
Windows 11 LOG analysis report.
Here’s a structured summary of the **“Hardening Microsoft Windows 10 and Windows 11 Workstations”** (July 2024) PDF from Australia’s Cyber.gov.au:

---

## 🛡️ High Priority Controls

1. **Application Security**

   * Disable unneeded features (e.g., Office macros, browser plugins).
   * Enable built‑in protections and apply vendor security baselines ([cyber.gov.au][1]).

2. **Patching & Versions**

   * Keep OS (Win 10 22H2 / Win 11 23H2) and applications (Office, browsers, PDF readers) fully patched ([cyber.gov.au][1]).

3. **Attack Surface Reduction (ASR)**

   * Enable ASR rules via Defender Exploit Guard (e.g., blocking obfuscated scripts, preventing Office apps from launching executables) ([cyber.gov.au][1]).

4. **Credential Protection**

   * Disable legacy WDigest authentication.
   * Enable Credential Guard with virtualization, secure launch, and kernel protections ([cyber.gov.au][1]).

5. **Controlled Folder Access**

   * Use Windows Defender feature to restrict unauthorized app access to protected folders ([cyber.gov.au][1]).

6. **Secure Credential Entry & UAC**

   * Enforce Secure Desktop for credential prompts.
   * Configure UAC to require admin consent and virtualize writes ([cyber.gov.au][1]).

7. **Early Launch Antimalware (ELAM)**

   * Enable ELAM drivers to inspect boot components before other drivers load ([cyber.gov.au][1]).

8. **Exploit Protection**

   * Activate system-wide protections (CFG, DEP, ASLR, SEHOP, etc.) in Defender ([cyber.gov.au][1]).

9. **Local Admin & Privilege Management**

   * Enforce strong password policies (≥30 chars, complexity).
   * Run admins in Admin Approval Mode and apply UAC restrictions on network logons ([cyber.gov.au][1]).

10. **Trusted Boot: Secure Boot & Measured Boot**

    * Enable Secure Boot (UEFI) and Measured Boot with TPM to protect boot integrity ([cyber.gov.au][1]).

11. **Browser Hardening**

    * Use Microsoft Edge with enforced auto‑updates and biometric protections via Windows Hello for Business ([cyber.gov.au][1]).

12. **Multi‑Factor Authentication (MFA)**

    * Require MFA for accounts (implied under credential protection priorities) ([cyber.gov.au][1]).

---

## ⚙️ Medium Priority Measures

* **Account Lockout**: Lock accounts after \~5 failed attempts with a 15‑minute reset ([cyber.gov.au][1]).
* **Disable Anonymous/Guest Network Access** .
* **Ensure Defender Settings**: Real‑time, behavior/script/process scanning remain enabled ([cyber.gov.au][1]).
* **Audit Logging**: Enable detailed system and account auditing for detection/forensics ([cyber.gov.au][2]).
* **Disable Network Bridging** and CD burning to reduce attack vectors ([cyber.gov.au][1]).
* **Device & Removable Storage Control**: Enforce BitLocker encryption (XTS‑AES 128), restrict execution from USB/CD ([cyber.gov.au][1]).
* **SmartScreen & Run‑once Lists**: Enable Defender SmartScreen and disable legacy autorun entries ([cyber.gov.au][1]).
* **Disable Microsoft Account Linking & NetBIOS** ([cyber.gov.au][3]).
* **Power Management**: Disable sleep/hibernation to avoid data leakage .
* **Registry & PowerShell Controls**: Disable registry editing tools and enforce PowerShell protections ([cyber.gov.au][1]).
* **RPC & Remote Services**: Enforce secure RPC settings; block unsafe remote usage .
* **Lock‑Screen & App Privacy**: Restrict lock‑screen notifications and voice activation .
* **Sound Recorder & WPAD**: Disable local audio recording and WPAD protocol ([cyber.gov.au][1]).

---

## 🔽 Low Priority (Optional)

* Display full file extensions.
* Disable Windows Store.
* Tweak UI settings like result of policy reporting.

---

### ✅ Implementation Notes

* Designed for Windows 10 Enterprise/Education and Windows 11 set-ups.
* Apply via Group Policy or Endpoint Manager equivalents.
* Always pilot in a testing environment to assess impact on workflows ([cyber.gov.au][4], [cyber.gov.au][1], [cyber.gov.au][5]).
* Though framed for workstations, most recommendations apply equally to servers (excluding DCs) ([cyber.gov.au][5]).

---

## 🧩 Strategic Takeaway

This guide delivers a layered defence strategy: **harden applications**, **seal OS vulnerabilities**, **secure credentials**, **protect boot and storage**, **enforce monitoring**, and **minimize unnecessary privileges or interfaces**. The goal is a resilient, enterprise-grade Windows posture that defends against modern threats—from script-based exploits to bootkits and credential theft.

Let me know if you'd like a deep dive into any section or assistance tailoring this to your environment.

[1]: https://www.cyber.gov.au/sites/default/files/2024-07/PROTECT%20-%20Hardening%20Microsoft%20Windows%2010%20and%20Windows%2011%20Workstations%20%28July%202024%29.pdf?utm_source=chatgpt.com "[PDF] Hardening Microsoft Windows 10 and Windows 11 Workstations"
[2]: https://www.cyber.gov.au/sites/default/files/2024-06/15.%20ISM%20-%20Guidelines%20for%20System%20Hardening%20%28June%202024%29.pdf?utm_source=chatgpt.com "[PDF] Guidelines for System Hardening - Information Security Manual"
[3]: https://www.cyber.gov.au/sites/default/files/2025-03/Essential%20Eight%20maturity%20model%20FAQ%20%28October%202024%29.pdf?utm_source=chatgpt.com "[PDF] Essential Eight maturity model FAQ - Australian Cyber Security Centre"
[4]: https://www.cyber.gov.au/sites/default/files/2024-06/Information%20Security%20Manual%20%28June%202024%29.pdf?utm_source=chatgpt.com "[PDF] Information Security Manual"
[5]: https://www.cyber.gov.au/resources-business-and-government/maintaining-devices-and-systems/system-hardening-and-administration/system-hardening/hardening-microsoft-windows-10-and-windows-11-workstations?utm_source=chatgpt.com "Hardening Microsoft Windows 10 and Windows 11 workstations"

