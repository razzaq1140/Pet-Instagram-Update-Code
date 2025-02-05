import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import '/src/common/utils/custom_snackbar.dart';
import '../../../_user_data/models/user_profile_model.dart';
import '../models/chat_message_model.dart';
import '../repository/individual_chat_repository.dart';

class ChatMessagesController extends ChangeNotifier {
  final IndividualChatRepository _repository = IndividualChatRepository();

  File? image;
  int? _chatId;
  int _currentPage = 1;
  int _totalPage = 1;
  String? _nextPageUrl;
  bool _isLoading = false;
  bool _loadingNewItems = false;
  final List<ChatMessageModel> _messages = [];

  late ScrollController scrollController;
  final FocusNode focusNode = FocusNode();
  final TextEditingController messageController = TextEditingController();

  bool get isLoading => _isLoading;
  bool get loadingNewItems => _loadingNewItems;
  List<ChatMessageModel> get messages => _messages;

  setChatId(int? id) {
    _chatId = id;
  }

  toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  clearAll() {
    _messages.clear();
    _nextPageUrl = null;
    _totalPage = 1;
    _currentPage = 1;
    _chatId = null;

    notifyListeners();
  }

  clearScrollController() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
  }

  void scrollListener() async {
    final minScroll = scrollController.position.minScrollExtent;
    final currentScroll = scrollController.position.pixels;

    if (!_loadingNewItems) {
      if (currentScroll >= minScroll + 100) {
        if (_nextPageUrl != null) {
          _loadingNewItems = true;
          await fetchMessages();
          _loadingNewItems = false;
        }
      }
    }
  }

  // ChatMessagesController() {
  //   // Pre-load messages
  //   _messagess.addAll([
  //     GroupMessage(
  //       text: 'Hello! How are you?',
  //       isSender: false,
  //       avatarUrl:
  //           'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
  //     ),
  //     GroupMessage(
  //       text: 'I am doing well, thank you!',
  //       isSender: true,
  //       avatarUrl:
  //           'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
  //     ),
  //   ]);
  // }

  // Send a text message
  // void sendMessage(String text) {
  //   if (text.isNotEmpty) {
  //     _messages.add(GroupMessage(
  //       text: text,
  //       isSender: true,
  //       avatarUrl:
  //           'https://as2.ftcdn.net/v2/jpg/05/78/79/17/1000_F_578791746_yleX4RjodpO0cIfhTAHI6KlgWq1Szows.jpg',
  //     ));
  //     messageController.clear();
  //     notifyListeners();
  //     _scrollToBottom();
  //   }
  // }

  // Pick an image from camera
  Future<void> pickImageFromCamera(VoidCallback onPicked) async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        image = File(pickedImage.path);
        onPicked();
      }
    } catch (e) {
      showSnackbar(message: 'Camera not available', isError: true);
    }
  }

  // Pick an image from gallery
  Future<void> pickImageFromGallery(VoidCallback? onPicked) async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        image = File(pickedImage.path);
        if (onPicked != null) {
          onPicked();
        }
      }
    } catch (e) {
      showSnackbar(
          message: 'There was an Issue. Please try again', isError: true);
    }
  }

  // Add reactions to messages
  void addReactionToMessage(
      {required ChatMessageModel message, required String reaction}) {
    // message.reactions.add(reaction);
    notifyListeners();
  }

  Future<void> fetchMessages() async {
    if (_chatId == null) {
      return;
    }
    try {
      /// If the operation is periodic, fetch the latest page data.
      /// Otherwise, fetch data from the [nextPageUrl]. If [nextPageUrl] is null,
      /// the first page endpoint is used. Otherwise, the [nextPageUrl] endpoint is used.

      Response? response = await _repository.fetchChatMesages(
          nextPage: _nextPageUrl, chatId: _chatId!);
      if (response != null) {
        var responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['data']['data'];
        _currentPage = responseBody['data']['current_page'];
        _totalPage = responseBody['data']['last_page'] ?? 1;
        _nextPageUrl = responseBody['data']['next_page_url'];
        if (_currentPage == _totalPage) {
          _nextPageUrl = null;
        }

        /// If the operation is periodic, add messages to the start of the queue.
        /// Otherwise, add them to the end of the queue.
        // if (isPeriodic == true) {
        //   for (var item in data) {
        //     var message = ChatMessageModel.fromJson(item);
        //     if (_messages.any((message) => message.id == message.id)) {
        //       continue;
        //     }
        //     log(message.toString());
        //     _messages.insert(0, message);
        //   }
        // } else {
        _messages.addAll(
            data.map((json) => ChatMessageModel.fromJson(json)).toList());
        // }

        _messages.map((message) => message).toSet().toList();
      } else {
        log('No messages data $response');
      }
    } catch (e) {
      showSnackbar(message: 'Error fetching messages $e', isError: true);
    } finally {
      notifyListeners();
    }
  }

  Future<void> sendMessage({
    String? message,
    File? image,
    required int otherId,
    required UserProfile user,
  }) async {
    try {
      Map<String, dynamic> map;
      if (message == null && image == null) {
        showSnackbar(message: 'Empty Message');
        return;
      } else if (message != null && image != null) {
        map = await _repository.sendMessageWithImage(
            otherId: otherId, message: message, image: image);
      } else if (message == null) {
        map = await _repository.sendImage(otherId: otherId, image: image!);
      } else {
        map = await _repository.sendMessage(otherId: otherId, message: message);
      }

      if (map.isNotEmpty) {
        String? imageUrl = map['image_url'];
        if (imageUrl != null) {
          if (imageUrl.contains('public')) {
          } else {
            final updatedUrl = imageUrl.replaceAll('uploads', 'public/uploads');
            imageUrl = updatedUrl;
          }
        }
        _messages.insert(
          0,
          ChatMessageModel(
            id: map['chat_room_id'],
            recipientId: otherId,
            senderId: user.id,
            isRead: false,
            createdAt: DateTime.now(),
            message: map['message'],
            image: imageUrl,
            sender: ChatMessageSenderModel(
              id: user.id,
              name: user.name,
              username: user.username,
              profileImage: user.profileImage,
            ),
          ),
        );
      }
      setChatId(map['chat_room_id']);
      messageController.clear();
      focusNode.unfocus();
      notifyListeners();
    } catch (e) {
      log('Error sending message: $e');
    }
  }
}

class GroupMessage {
  final String? text;
  final String? imageSend;
  final String? avatarUrl;
  final bool isSender;
  List<String> reactions = [];

  GroupMessage({
    this.text,
    this.imageSend,
    this.avatarUrl,
    required this.isSender,
  });
}
