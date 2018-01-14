#!/bin/bash
CDIR=$(pwd)
if [ $1 != "" ]; then 
    filename="${$1%.*}"
    if [ -f ~/.wine/drive_c/Python27/pyfor_exe/$filename.py ]; then 
        rm -f ~/.wine/drive_c/Python27/pyfor_exe/$filename.py
    fi 

    if [ -f $filename.py ]; then 
        cp $filename.py ~/.wine/drive_c/Python27/pyfor_exe/
        # run `pyinstaller` under the same directory as Python scripts
        cd ~/.wine/drive_c/Python27
        wine Scripts/pyinstaller.exe --onefile pyfor_exe/$filename.py
    fi

    if [ $2 != "" ] && [ -f dist/$filename.exe ]; then 
        cp dist/$filename.exe $2
    elif [ -f dist/$filename.exe ]
        cp dist/$filename.exe $CDIR
    fi
fi
