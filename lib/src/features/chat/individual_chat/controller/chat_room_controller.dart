import 'package:flutter/material.dart';
import '/src/common/utils/custom_snackbar.dart';
import '../models/chat_room_model.dart';
import '../repository/individual_chat_repository.dart';

class ChatRoomController extends ChangeNotifier {
  final IndividualChatRepository _repository = IndividualChatRepository();

  //Creating a group
  bool _isLoading = false;
  bool _firstTimeLoading = true;
  bool _isBusy = false;
  List<ChatRoomModel> _chatList = [];
  List<ChatRoomModel> _filteredChatList = [];

  bool get isLoading => _isLoading;
  bool get firstTimeLoading => _firstTimeLoading;
  bool get isBusy => _isBusy;
  List<ChatRoomModel> get chatList => _chatList;
  List<ChatRoomModel> get filteredChatList => _filteredChatList;

  toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  toggleBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  filterList(String query) {
    _filteredChatList = _filteredChatList.where((chat) {
      return chat.otherUser.name.toLowerCase().contains(query.toLowerCase()) ||
          chat.otherUser.username.toLowerCase().contains(query.toLowerCase());
    }).toList();
    notifyListeners();
  }

  Future<void> fetchChats() async {
    try {
      toggleLoading();
      _firstTimeLoading = false;
      _chatList = await _repository.fetchChats();
      _filteredChatList = _chatList;
    } catch (e) {
      showSnackbar(message: 'Error Fetching chat.', isError: true);
    } finally {
      toggleLoading();

      notifyListeners();
    }
  }
}
