# Pragmatic Linux

***
Pragmatic Linux Build is used to compile,build the pragmaticlinux distro and make it ready for production use.


# Usage

***
**prepare.sh**
Used to prepare the data, backup current configuration system and compress it to one file compression.

**praginstall.sh**
Its used to install Pragmatic Linux on Guest Machine.

**build.sh**
It will build the system,compile,configure,implement feature.  


# Workflow step-by-step usability

***
Builiding the pragmatic linux distro.

**Requirments**

- Root Privileges over the system
- To be located at /root/
- ArchLinux Base System
- mkarchiso, archiso package into archlinux repo

Go as root user
> su root 

> cd /root

> git clone https://github.com/PragmaticLinux/PragmaticBuild.git pragmaticbuild

> cd pragmaticbuild

Now the After all this the environment its ready and its can be builded.

Every change you do on the live system you are working you should follow just those 2 steps

Execute those two script as follow
> sh prepare.sh
After executing completed copy the file PragmaticLinux*.tar.gz and move it to work/airootfs/

now its time to execute the build.sh
> sh build.sh

this will build and compile everything inside of it. At the end it will output an .iso which can be used to boot from any machine. the output is generated at **/srv/http/** so write it to an USB or DVD and test it.

the third step is optional and it has to do with praginstall.sh script
when you are abel to boot on builded system sexecute
> sh Pragmatic.sh

And follow the guide of scripts if you need help on how to use installation then go ahead at documentation of www.pragmaticlinux.org in menu Documentation




## License & Agrements
***

- **[MIT license](http://opensource.org/licenses/mit-license.php)**
- **Copyright 2016  © Alban Mulaki**

> Copyright (c) 2016 Alban Mulaki

>Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

>The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

