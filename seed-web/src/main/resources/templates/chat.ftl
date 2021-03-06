<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8"/>
    <title>Spring Boot WebSocket Demo</title>
</head>
<body>
<noscript>
    <h2 style="color:#ff0000">貌似你的浏览器不支持websocket</h2>
</noscript>
<div>
    <div>
        <button id="connect" onclick="connect()">连接</button>
        <button id="disconnect" onclick="disconnect();">断开连接</button>
    </div>
    <div id="conversationDiv">
        <label>名字:</label> <input type="text" id="name"/>
        <br>
        <label>消息:</label> <input type="text" id="messgae"/>
        <button id="send" onclick="send();">发送</button>
        <p id="response"></p>
    </div>
</div>
<script src="https://cdn.bootcss.com/sockjs-client/1.1.4/sockjs.min.js"></script>
<script src="https://cdn.bootcss.com/stomp.js/2.3.3/stomp.min.js"></script>
<script src="https://cdn.bootcss.com/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript">
    var stompClient = null;
    //websocket网关的地址
    var host = "http://127.0.0.1:9090";

    function setConnected(connected) {
        document.getElementById('connect').disabled = connected;
        document.getElementById('disconnect').disabled = !connected;
        document.getElementById('conversationDiv').style.visibility = connected ? 'visible' : 'hidden';
        $('#response').html();
    }

    function connect() {
        //地址+端点路径，构建websocket链接地址,注意，对应config配置里的addEndpoint
        var socket = new SockJS(host + '/websocket/chat' + '?token=456');
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function (frame) {
            setConnected(true);
            console.log('Connected:' + frame);
            //监听的路径以及回调
            stompClient.subscribe('/user/queue/sendUser', function (response) {
                showResponse(response.body);
            });
        });
    }


    // function connect() {
    //     //地址+端点路径，构建websocket链接地址,注意，对应config配置里的addEndpoint
    //     var socket = new SockJS(host + '/websocket/chat' + '?token=123');
    //     stompClient = Stomp.over(socket);
    //     stompClient.connect({}, function (frame) {
    //         setConnected(true);
    //         console.log('Connected:' + frame);
    //         //监听的路径以及回调
    //         stompClient.subscribe('/topic/sendTopic', function (response) {
    //             showResponse(response.body);
    //         });
    //     });
    // }

    function disconnect() {
        if (stompClient != null) {
            stompClient.disconnect();
        }
        setConnected(false);
        console.log("Disconnected");
    }

    function send() {
        var name = $('#name').val();
        var message = $('#messgae').val();
        // 发送消息的路径,由客户端发送消息到服务端
        //stompClient.send("/websocket/sendServer", {}, message);

        // 发送给所有广播sendTopic的人,客户端发消息，大家都接收，相当于直播说话 注：连接需开启 /topic/sendTopic
        //stompClient.send("/websocket/sendAllUser", {}, message);

        // 注意，需要通过不同的前端html进行测试，需要改不同token ，例如 token=1234，token=4567
        stompClient.send("/websocket/sendMyUser", {}, JSON.stringify({name: name, message: message}));
    }

    function showResponse(message) {
        var response = $('#response');
        response.html(message);
    }
</script>
</body>
</html>