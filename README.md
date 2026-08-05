# Mule Secure Studio

> A local Windows desktop utility for encrypting and decrypting Mule secure properties without repetitive command-line work.

[![Latest Release](https://img.shields.io/github/v/release/rlondhe98/mule-secure-studio?label=Latest%20Release&color=00A1DF)](https://github.com/rlondhe98/mule-secure-studio/releases/latest)
[![Platform](https://img.shields.io/badge/Platform-Windows-007CB8)](https://github.com/rlondhe98/mule-secure-studio)
[![Java](https://img.shields.io/badge/Java-17%20Required-006C9C)](https://www.oracle.com/java/technologies/downloads/#java17)
[![License](https://img.shields.io/badge/License-Add%20a%20license-lightgrey)](LICENSE)

Mule Secure Studio provides a modern graphical interface for the MuleSoft Secure Properties Tool.

Instead of manually writing and editing long Java commands, users can select files, enter values, choose encryption settings, preview generated output, copy results, and export files only when needed.

---

## Features

- Encrypt and decrypt a **single value**
- Encrypt and decrypt **YAML**, **YML**, and **`.properties`** files
- Support property-value encryption inside a file
- Support full file-level encryption
- Preview generated output before exporting
- Copy encrypted or decrypted values directly to the clipboard
- File-picker support for input configuration files
- Optional output export
- Local key entry with masked input
- Show/hide encryption key option
- Supports multiple algorithms and modes
- Responsive Windows desktop GUI
- No browser upload or online processing required

---

## Download

Download the latest Windows executable:

➡️ **[Download Mule Secure Studio for Windows](https://github.com/rlondhe98/mule-secure-studio/releases/latest/download/MuleSoftSecureProperties.exe)**

View all releases:

➡️ **[GitHub Releases](https://github.com/rlondhe98/mule-secure-studio/releases)**

---

## Prerequisites

### Java 17 is required

Mule Secure Studio uses the MuleSoft Secure Properties Tool JAR, which requires Java to run.

Before launching the application, ensure that **Java 17** is installed and available in your Windows `PATH`.

Open Command Prompt or PowerShell and run:

```powershell
java -version
