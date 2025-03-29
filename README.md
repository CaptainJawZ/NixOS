
# Notas

Como te comente este clon, esta limpiado de mi repositorio original, borre algunos
scripts que son muy específicos para mi y otras cosas que contenían secretos &
dotfiles que no te serian útiles.

No creo que vayas a tener errores de compilación, siento que si lo instalas tal
cual, si te va a generar un sistema, pero pues a consideración de que, como
todos los scripts de servidores tienen los secretos o comentados o remplazados
con "supersecret", es posible que a la hora de iniciar, pues... si te creen
conflictos.

Mi recomendación, es compilar NixOS sin ningún servidor activo (adelante detallo
como), y conforme tu interés, vas activando algunos, des-comentando las lineas
de secretos tras su creación.

## Pasos para instalar

### Paso 1. hardware-configuration.nix

Si ya instalaste nixos, no hay problema, de hecho creo que lo mejor es que lo
instales desde el instalador oficial, porque es mas fácil, en teoría se puede
instalar desde mi flake, con un nixos-install --flake github@repo#workstation,
pero para que sufrir, posiblemente de algunos errores por hardware.

Cuando instalas nixos, te genera 2 archivos en /etc/nixos/

- configuration.nix este lo puedes ignorar
- hardware-configuration.nix este es importante.

Copia el de hardware-configuration.nix, y si quieres remplazarlo con los que
tengo en mi repo, dentro de ./hosts/{}/hardware_configuration.nix

Porque, pues nix te genera este fichero según las especificaciones de tu
computadora, y automáticamente le pone los esquemas de partición de disco duro,
format, boot, etc que hayas elegido, quizá puedas copiar algunas cosas de mis
ficheros, como mi swap encryptada, etc, pero no son necesarios, realmente
ahorita no te preocupes por esto.

### Paso 2. remplaza jawz con tu usuario

Es mi usuario predilecto y el único que creo, simplemente ejecuta este comando,
excluí jawz-scripts porque es el nombre del otro repositorio que te voy a
compartir.

También, cámbiale el nombre a jawz.nix por newusername.nix.

Y ya con esto no creo que te de errores.


```bash
nix run nixpkgs#fd --  . -tf -x sed -i '/jawz-scripts/!s/\bjawz\b/newusername/g' {} \;
```

Opcional, pero si quieres también ajusta el hostname, en las carpetas de
./hosts/nombre/configuration.nix, por el nombre que quieras que tus computadoras
tengan, obviamente remplaza el nombre de la carpeta padre, etc, y ejecuta un
comando parecido al seed, que remplace por ejemplo workstation con tu nuevo
hostname.

```nix
...
    hostName = "workstation"
...
```

### Paso 3. compila el flake
Asumiendo que dejaste los nombres de mis computadoras, tienes dos opciones:

1. workstation: tiene interface de usuario, básicamente es mi computadora
   personal, te instalara un entorno grafico, con walpaper, steam, emuladores,
   muchas cosas, te dejare toggles.nix como lo tengo, pues no tiene nada que
   creo que se rompa, eso si, va a ser bloat, ya a tu gusto borras lo que
   quieras.
2. miniserver: te comente de toggles.nix los servidores, y vpn, la vpn yo creo
   que si te va a servir una vez le pongas tus secretos, para que tengas
   jeancarlos_vpn.

server, es básicamente lo mismo que miniserver, pero lo uso para otros
servidores que miniserver no usa, por ejemplo, daniloflix, etc, simplemente por
como tengo mi infraestructura, si quieres deployar jeancarlosflix estoy seguro
que te va a funcionar en tu minipc, mi idea es a futuro homologar server y
miniserver, ahorita es mas que nada tema de discos duros y donde tengo la data
que el server ocupa, así que ignora server, borrarlo si quieres.

Para instalar, te recomiendo clonar el repositorio a ~/Development/NixOS, esto
hará que una variable de entorno te funcione transparente-mente, para usar nh.

Pero para tu primera instalación, haz un (nota si cambiaste el hostname, ponlo
despues de #):

```bash
cd ~/Development/NixOS
sudo nixos-rebuild boot --flake .#workstation
```

Reinicia tu computadora y te booteara a mi configuracion, recuerda que si falla,
en el menú de boot puedes arrancar desde tu ultima configuracion de nixos, para
que no tengas dolores de cabeza reinstalando nixos.

Como esto te cargara todos mis programas y configuraciones de nix, la próxima
vez, puedes compilar usando nix helper que tiene una mucho mejor interface
grafica, simplemente ejecuta alguno de los siguientes comandos, harán lo mismo.

```bash
nh os build
nh os boot
nh os switch
```

## Consideraciones

### home-manager

Te daras cuenta, que yo tengo mi home-manager fusionado con nix, esto es, muy
poco ortodoxo, de hecho ni lo vi en ninguna tutorial así que sepa si haya gente
que haga esto jajaja, para mi se me hace fácil, configurar python a nivel
programa y a nivel home-manager desde python.nix... hasta hace una semana,
esto nunca me ocasiono un problema, y recientemente tuve uno con emacs, pero,
dudo que si quiera vayas a usar emacs y es mas problema del modulo que
instale, que culpa mía.

### stylix

Stylix es genial, automagicamente, desde tu wallpaper, genera una paleta de
color que aplica a 99% de tu interface grafica, literal hasta hace 1 semana que
cambiaron la GUI de discord, INCLUSO te themeaba discord, es casi 0 conf, solo
tienes que ponerle el path a tu walpaper en stylix.nix y boom.

### ghostty

Es una nueva terminal, algunos programas te van a dar errores, pero la estoy
probando, pero si quieres usa console, o si instalas plasma, quedate con su
terminal, no es obligatorio que uses ghostty.

### doom-emacs

Al igual que ghostty, mi editor default es doom-emacs, si no quieres usarlo una
buena practica para ti seria quitar emacs como #1, y luego instalar vs code, o
cualquiera que prefieras.

### librewolf

Te va a borrar todo el historial y cookies cada que cierres tu navegador, es su
comportamiento default jaja, remplazalo por firefox o google-chrome, en
internet.nix.

## Consejos sobre los secretos

PS: la administracion de secretos es IGUAL de castrante en
Ubuntu/Fedora/cualquier otro OS, no pienses que es Nix :V, nix al menos te da la
opcion de declarar 1 vez y ya te despreocupas para todos tus mini-pc.

Cuando veas los ficheros dentro de modules/servers/*.nix, veras que las únicas
lineas comentadas son de sops, obviamente recomiendo darle una leída a la
documentación, pero para que le hagas un wrap de como funciona, este es el
flujo.  https://github.com/Mic92/sops-nix

1. Generas una llave sops basada en tu llave ssh, mientras tengas acceso a esta
   llave, puedes siempre re-generar tu llave de sops para desencryptar seguros,
   incluso nix puede hacerlo.  así que realmente es algo que tienes que hacer
   solo una vez, y mantener tu llave ssh fuera de tu repo, así que es un paso
   semi-automatico, solo tendrías que copiar la llave a nuevas computadoras y
   listo.
2. Te metes a la carpeta de ./secrets y corres sops fichero.yaml, esto abrirá el
   yaml desencryptado en tu editor.
3. Este es un yaml, donde puedes poner secretos, te muestro 3 ejemplos.
4. Guarda el yaml, y ya solo queda llamar el secreto en tu configuracion,
   tambien te pondre un ejemplo.

Cada linea del yaml, va a ser guardada en un archivo, que nix pondrá en
/run/secrets/nombre, y pues cuando le digas a un servidor "saca el secreto de
este path" pues el servidor leerá el archivo y el sabrá que hacer con la
información contenida.

considera que en yaml ': |' significa que todas las lineas que estén endentadas
a ese nivel, van a ser parte de este bloque, por lo que se usa para definir
archivos en múltiples lineas.

```yaml
ryot: |
    VIDEO_GAMES_TWITCH_CLIENT_ID=000000000000000000000000000000
    VIDEO_GAMES_TWITCH_CLIENT_SECRET=000000000000000000000000000000
public_keys:
    age: ssh-ed25519 0000000000000... age@workstation
private_keys:
    age: |
        -----BEGIN OPENSSH PRIVATE KEY-----
        ...
        -----END OPENSSH PRIVATE KEY-----
```

En los ejemplos que te muestro, el primero lo referenciarías como "ryot" porque
es el nombre del secreto a este nivel, en este caso tiene muchas lineas, y si te
fijas tiene el formato de un .env file, y es porque pues básicamente es lo que
vamos a guardar, un .env con variables de entorno que ryot leerá, como en este
caso ryot es un docker, pues básicamente le estamos montando el .env file, como
si fuera un docker-compose.

```nix
sops.secrets.ryot.sopsFile = ../../secrets/env.yaml;
virtualisation.oci-containers.containers.ryot.environmentFiles = [ config.sops.secrets.ryot.path ];
```

Ahora, si te fijas, public_keys y private_keys tienen niveles, como mandas a
llamar a los hijos en nix? simple con ".", puedes poner las comillas dentro de
declaraciones de nix, para que escape el punto.

Yo personalmente, guardo las public_keys en mi repositorio de nixos, eso es
seguro, y las private dentro de sops, por ahi en mi archivo veras que uso esto
para instalar llaves en varios lugares, ssh, workers, etc.

```nix
sops.secrets."public_keys.age".sopsFile = ../../keys.yaml;
bla.bla.bla.secretFile = config.sops."public_keys.age".sopsFile.path;
```

Y ya, es toda la ciencia, realmente sopsFile no es necesario, pero yo puse todos
mis secretos en diferentes archivos, para organizar, sopsFile simplemente le
dice en que yaml buscar el secreto.

Hay servidores, donde veras otras configuraciones de sops, como ownership, etc,
pero estos son casos muy específicos, básicamente le das permisos a nginx, u
otro usuario, de leer ese secreto.

- Para 99% de los secretos, cualquier generador te va a generar, un texto entre
32-64 caracteres aleatorio debería ser mas que suficiente.
- Otros secretos son llaves API, que pues vas a generar en la interface, por
  ejemplo una API de Jellyfin, que vas a poner en Sonarr para que Sonarr pueda
  notificar a Jellyfin que hay un nuevo episodio, estos dudo que te rompan la
  funcionalidad del servidor, solo pues te va a dar warnings que no se pudieron
  conectar.
- El único que se me viene a la mente (pero puede que haya mas) que ocupa de un
  formato/generador especifico para generar sus secretos y llaves, es syncthing,
  si te interesa ese me dices y te ayudo a generarlos.
