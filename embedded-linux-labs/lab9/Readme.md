# Lab 9 - Set up CGI app server

This lab requires you to have set up lighttpd server on raspi as instructed in Lab 8.

## Step 1: Set up CGI for lighttpd

Enable cgi mod:
```
pi@raspberrypi:~ $ sudo lighty-enable-mod cgi
```

Replace default assignments in `/etc/lighttpd/conf-enabled/10-cgi.conf` with 
```
    cgi.assign      = (
        ".sh"  => "/usr/bin/bash",
        ".py"  => "/usr/bin/python",
        ".cgi"  => "",
    )
```
> The assigment part means that url example https://xx.xx.xx.xx/cgi-bin/demo.sh will create a new shell process (environment vars containing request parameters), and it automatically runs `/usr/bin/bash /usr/lib/cgi-bin/demo.sh`, collects all stdout output and sends that as response to browser request.
> To run binary code, it is necessary to use file suffix ".cgi" so that binary files recognised correctly. Normally in linux, executables do not have file suffixes (whereas in Windows they are ".exe")

Copy example pydemo.py file from this repository into `/usr/lib/cgi-bin/pydemo.py` 

By default, lighttpd uses HTTP/2 connections but does not manage them well, so you might get error when using https connections. To avoid that you can disable the HTTP/2 support in main configuration file by replacing the contents as

```
server.feature-flags       += ("server.h2proto" => "disable")
server.feature-flags       += ("server.h2c"     => "disable")

```
Finally, reload:
```
pi@raspberrypi:~ $ sudo service lighttpd force-reload
```
and check operation with browser `https:/xx.xx.xx.xx/cgi-bin/pydemo.py`.  
> **Troubleshooting**:  
> If `500 internal server error`, check that you really can run the python code: `python /usr/lib/cgi-bin/pydemo.py` and also directly as `/usr/lib/cgi-bin/pydemo.py` so the file need to be executable (x flag set).  
Additionally, it is required that the binaries can run as user `www-data` which may bring new problems that are shown as internal server error. To see how your binary behaves when it is run as other user, try runuser and sort out the problems there:
>```
>pi@raspberrypi:~ $ sudo runuser -u www-data -- /path/to/my/binary
>```
Note that every time you change the content of cgi-bin contents, you must reload configuration before changes take effect! In contrast, if you change statically served html file content, reload is not required.

QUESTION 1: Get your python page content to a file in VM using `curl` and and redirect the output to lab9/results/mypython.html, commit and push. 

## Step 2: Run binaries built from C code

You can now copy your ledon / ledoff binaries (from lab4/4.0) to cgi-bin folder. Remember to rename them with suffix .cgi to comply with your cgi configuration. Test. Do troubleshooting as above in python case.

**NOTE** that in order to be able to play with gpio, you need to be member of gpio group. But, who is 'you' in this case? Not the user 'pi', but user 'www-data'. If you add group memberships to any user, the new settings apply only to processes started after the update --> you need to add user www-data to gpio group, and then restart lighttpd process, so that the cgi programs can inherit gpio membership. (In other words, when lighttpd service is started, it gets the current group memberships. Every time there is a web access that triggers cgi programs, a new child process is started where the program is run. That child process inherits the group memberships from parent process, so it is necessary to restart the service so that group memberships are updated to cgi scripts as well.)  


## Step 3: Develop CGI programs using C

In a more realistic setup you would want to give parameters for the binary executable. In the led on/off case you might want have more generic interface for any GPIO pin and operate it with http commands like `https://xx.xx.xx.xx/cgi-bin/set-gpio.gci?pin=12&state=1`

Every CGI request will run the binary in fresh new shell, and all parameters are transmitted via shell environment variables. How can we develop cgi apps efficiently?
1. We need to know exactly how the http query parameters are translated into env variables
2. We can then replicate any request content in env vars 
    - in vscode, you can edit launch configuration top include environment vars as in https://stackoverflow.com/questions/29971572/how-do-i-add-environment-variables-to-launch-json-in-vscode
    - on CLI, by prepending env vars to executable:
```
pi@raspberrypi:~ $ DOCUMENT_ROOT=/usr/lib/cgi-bin/ REQUEST_METHOD=GET SERVER_PROTOCOL=HTTP/1.1 ./mycgitest.cgi
```

So we need to find out what are the env vars provided by CGI interface. Fortunately, someone has already solved this phase whis this c code 
https://www.lemoda.net/c/cgi-getenv/env-cgi.c

Try it out:
1. Create vscode C cross-compile project in subfolder lab9/9.3
2. Replace main.c content with contents of file link above & build project. 
3. You should be able to edit and debug the code normally. Additionally, it is served by lighttpd. **Note that these two are two different processes: debugger runs one instance of yourapp; and CGI interface triggers another instance. So you cannot set debugger breakpoints to the instance that was triggered by web request.**  And you shouldn't need to, because the whole interface is defined by env vars and stdout. Those you can test separately. Let's solve that in next steps.
4. In browser, add query part to url, using any arbitrary parameters: for example https://xx.xx.xx.xx/cgi-bin/env-cgi.cgi?servoposition=90&led=on You should see those vars in output text.
5. Create a C code that detects servoposition=value in query part, and either controls PWM output accordingly, or prints an event line to a log file (in case you don't have GPIO hardware).   
(In a more realistic case you would parse the query part to handle multiple commands. **This has security implications** if you do not take care of buffer overflows, payload sanitation etc. So it is highly recommended to choose tested parser code, maybe https://github.com/jacketizer/libyuarel). Here, remember we are developing interface for a single local user.

The deliverable for this part is the project and code in folder lab9/9.3

## Step 4: Detect events from server

Standard http traffic is strictly client to server. Client sends request, and server responds. There is no way server could take initiative and send data to client. To solve this there are a couple of standard solutions:
1. Polling. Client asks regularly (like every second) status from server. Cons are that there is lots of unnecessary traffic, and event detection can be up to one polling interval unit late.
2. Long polling. Clinet sends request, and servers starts responding immediately, but keeps holding the end of transmission "Hoooo...ooold on", up to several minutes. When there is new data, server can immediately send rest of response message. When client gets something, it sends a new request and long poll gets repeated.
3. Web sockets are TCP sockets tunneled on http traffic, and they are basically bidirectional.

In this step you'll set up standard polling to get data from the server.
1. Create vscode project in subfolder lab9/9.4 for a code that responds with current time. Create CGI project as you did in step 7.  Get the c code `time.c` from this repo. Build, test and deploy to /usr/lib/cgi-bin folder. Try with browser.
2. The polling takes place in browser, so you need to set up a javascript snippet on your statically served web page. Get the html from this repo `poll-demo.html` and copy it to your web server static content folder. Open the page with browser and verify that you keep getting new data every second.  

> Up-to-date browsers do not allow javascript content to access arbitrary web locations for security reasons. When browser fetches the html page containing the script, the html reply from server should contain a header field named "Access-Control-Allow-Origin" where the server lists the allowed ip addresses to be accessed. (Malicious actor may be able to inject scripts into page content with relative ease, but changing the html reply message headers would require access to server configuration i.e. full access to server).  

To verify that your browser refuses to run the cgi code from script, checkl the browser-server communication using browser developer mode. In (Firefox) "Network" section you'll see a CORS error if server hasn't provided list of allowed IP's / domain names. You can also study the request/reply message headers with same tool.

To fix the CORS problem, you need to add a new mod to lighttpd configuration to allow setting reply headers as in https://redmine.lighttpd.net/projects/lighttpd/wiki/Mod_setenv and add the header field as 

```
setenv.add-response-header += (
   "Access-Control-Allow-Origin" => "*"
)
```

In the example above, you would allow any served script to access any IP, thus voiding the intended protection... for our demo purposes it is OK.

Now using CGI means there is a new process created every second. In raspi, check CPU load (use `top` for example). Adjust the polling rate until raspi load is 20% (btw, why is it difficult to get past 25% load? You'd think 100% is possible, right?) What is the polling interval then? The script takes only integer rate values, so you need to edit the script or add more clients to the test to load the server.  

QUESTION 4: Commit your result for polling interval for 20% load to file lab9/9.4/results/load20rate.txt. Typical metric for server capacity is "handled requests per second", so you want to express the result in that quantity.

