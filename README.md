# line-notify-from-cli


## Where to use?

I study this topic is because when I do a full build in a compile server. It is good if I can get a notify message when the build process is done.

For example, use the following command:

	$ make; ./line-notify.sh "build is done"


## How to use


### 1. Get your Access Token

Generating personal access tokens by navigating to [My page](https://notify-bot.line.me/my/) (LINE account required).

for more details please visit the website: [Using LINE Notify to send messages to LINE from the command-line](https://engineering.linecorp.com/en/blog/using-line-notify-to-send-messages-to-line-from-the-command-line/)


### 2. Edit the script


	$ vi ./line-notify.sh


change the following variables values:

* **access_token** - replace with your personal access token.
* **is_show_img** (optional) - if set the value to 1, assign a image URL to **IMG_URL** variable.


### 3. Have fun :-)

#### case1: send a simple message

The command example:


	$ ./line-notify.sh "hello LINE notify :-)"


the notification you got in LINE.


![](images/line-notify-01.png)


#### case2: send multiple messages

You can prepare a file that including your messages. For example:


	$ cat ex-msg.txt 
	hello~
	
	This is a test message from CLI
	 
	    (Y)      /)_/)
	   (. .)    (.  .)
	 o(")(")   C(")(")
	
	multiline messages test :-)


The command example:


	$ ./line-notify.sh < ex-msg.txt


the notification you got in LINE.


![](images/line-notify-02.png)


~ END ~

