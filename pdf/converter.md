# Convert JPEG to PDF using ImageMagick

This guide provides steps to convert JPEG files to PDF format using the `ImageMagick` tool on Ubuntu.

## Installation

First, ensure that ImageMagick is installed on your system. You can install it using the following commands:

```sh
sudo apt-get update
sudo apt-get install imagemagick
```

## Configuration Change

If you encounter an error related to security policies when attempting to convert JPEG files to PDF, you may need to update the ImageMagick policy configuration.

1. Open the policy.xml file for editing:

    ```sh
    sudo nano /etc/ImageMagick-6/policy.xml
    ```

2. Find the section related to the PDF format. It should look something like this:

    ```xml
    <policy domain="coder" rights="none" pattern="PDF" />
    ```

3. Change the `rights` attribute from `none` to `read|write`:

    ```xml
    <policy domain="coder" rights="read|write" pattern="PDF" />
    ```

4. Save the file and exit the editor (`CTRL + O` to save and `CTRL + X` to exit in nano).

## Usage

To convert a JPEG file to a PDF, use the following command:

```sh
convert input.jpg output.pdf
```
