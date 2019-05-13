# HackBash

<img width="1900" alt="demo" src="img/demo.png"/>

> <b>*Function, script and trick for file .bashrc and more _!_.*</b>


# Descrizione

Raccolta di funzioni e script che servono a facilitarti la vita. Per una dettagliata documentazione sulle funzioni, consultare https://vincenzogianfelice.github.io/HackBash.

# Installazione

_Potete scegliere **tre** opzioni:_

***Inserire tutto il contenuto nel proprio file '.bashrc' in questo modo:***

```
        find HackBash/src/ -type f -exec cat'{}' >> ~/.bashrc ';'
```

***Inserire tutto in una cartella e lanciarli tutti tramite il file '.bashrc':***

```
        mkdir ~/.script
        find HackBash/src/ -type f -exec cp '{}' ~/.script/ ';'
        chattr +i ~/.script		# Protezione in caso di cancellazione
        nano ~/.bashrc
```

>*E in fondo al file inserire le seguenti righe:*


```
        if [ -d ~/.script ]; then
           for i in ~/.script/*; do
           if [ -r $i ]; then
              . $i
           fi
           done
           unset i
        fi
```

***Copiare i file nella propria home:***

```
        cp HackBash/src/bashrc ~/.bashrc        ### ATTENZIONE! In questo modo, verra sovrascritto il file precedente con quello nuovo.
        cp HackBash/src/bash_aliases ~/.bash_aliases
        cp HackBash/src/functions/bash_functions  ~/.bash_functions
```
Per lanciarli potete digitare:

```
        . ~/.bashrc
```
o rieffettuare il login.

# Donazioni

**BTC:** *3EwV4zt9r5o4aTHyqjcM6CfqSVirSEmN6y*

# Contatti

**Email:** *developer.vincenzog@gmail.com*
