# xSF_OS
![](https://github.com/Saket-Upadhyay/xSF_OS/blob/main/screenshots/Step1/xSFOSpen.png)

[[हिन्दी में पढ़ें](https://github.com/Saket-Upadhyay/xSF_OS/blob/main/Readme_HI.md)]
### Progress

- [x] Base Code, Boot loader, simple assembly prints "SU" at boot (14/03/2021)
- [x] Enable longmode (64bit), setup Paging and Stack, prints "SAKET." at boot (16/03/2021)
- [x] Call subroutine from C code, Print String, Control Foreground and Background color. (19/03/2021)

### Toolchain

You can use docker to get whole toolchain already set-up in a docker image.

Get the image from Docker Hub by -
- ```docker pull x64mayhem/xsfos-dev:latest```

Then, open a terminal in root directory of project and run 

**Linux / \*nix** 

- ```docker run --rm -it -v "$pwd":/root/env x64mayhem/xsfos-dev```

**Windows (Poweshell)**

- ```docker run --rm -it -v "${pwd}:/root/env" x64mayhem/xsfos-dev```

> This project is is a work in progress, full documentation will be available after completion, so that I can explain everything better and share my notes.

### Screenshots 

###### 1. Base Code, Boot loader, simple assembly prints "SU" at boot 
![](https://github.com/Saket-Upadhyay/xSF_OS/blob/main/screenshots/Step1/Step1.png)

###### 2. Enable longmode (64bit), setup Paging and Stack, prints "SAKET." at boot
![](https://github.com/Saket-Upadhyay/xSF_OS/blob/main/screenshots/Step2/step2.png)

###### 3. Call subroutine from C code, Print String, Control Foreground and Background color.
![](https://github.com/Saket-Upadhyay/xSF_OS/blob/main/screenshots/Step3/Step3.png)

---

Footnote: 
Currently, I am trying to get a clear and deep understanding of Computer Architecture, Linux Kernel, Memory Management and other core topics.
(I am learning from different books, youtube videos, and opensource projects, and reflecting all this in my project.)

End goals for xSFOS are -

- [ ] To create well-structured documentation and proper releases on Git so that anyone can trace my steps and learn the same concepts.
- [ ] Ultimately converting this into a very basic but strong academic tool to aid the teaching of these somewhat difficult to understand, but crucial concepts.

If that sounds good to you, feel free to track the project or collaborate ^\_^
