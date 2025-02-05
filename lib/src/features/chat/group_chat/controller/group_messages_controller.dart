import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import '/src/features/chat/group_chat/repository/group_chat_repository.dart';
import '/src/features/chat/group_chat/repository/group_messages_repository.dart';
import '../../../../common/utils/custom_snackbar.dart';
import '../../../../common/utils/image_picker_helper.dart';
import '../../../_user_data/models/user_profile_model.dart';
import '../../../follower/models/follower_model.dart';
import '../model/group_member_model.dart';
import '../model/joined_chat_group_model.dart';
import '../model/message_model.dart';

class GroupMessagesController with ChangeNotifier {
  final GroupMessagesRepository _repository = GroupMessagesRepository();
  final GroupChatRepository _chatRepository = GroupChatRepository();
  late ScrollController scrollController;
  final TextEditingController messageController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool _isLoading = false;
  bool _isBusy = false;
  bool _loadingNewItems = false;
  bool _loadingMembers = false;
  bool _isLoadingFollwers = false;
  String? _nextPageUrl;
  int _currentPage = 1;
  int _groupId = 0;
  int _totalPage = 1;
  File? image;
  File? groupImage;
  JoinedChatGroupModel? _currentGroup;

  final List<GroupMemberModel> _memberList = [];
  final List<GroupChatMessageModel> _messages = [];
  final List<int> _selectedFollowers = [];
  final List<FollowerModel> _followerFollowingList = [];
  List<FollowerModel> _filteredFollowerList = [];

  bool get isLoading => _isLoading;
  bool get isBusy => _isBusy;
  bool get loadingMembers => _loadingMembers;
  bool get loadingNewItems => _loadingNewItems;
  bool get isLoadingFollwers => _isLoadingFollwers;
  JoinedChatGroupModel? get currentGroup => _currentGroup;
  List<GroupMemberModel> get memberList => _memberList;
  List<GroupChatMessageModel> get messages => _messages;
  List<int> get selectedFollowers => _selectedFollowers;
  List<FollowerModel> get followerFollowingList => _followerFollowingList;
  List<FollowerModel> get filteredFollowerList => _filteredFollowerList;

  toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  toggleBusy() {
    _isBusy = !_isBusy;
    notifyListeners();
  }

  toggleLoadingMembers() {
    _loadingMembers = !_loadingMembers;
    notifyListeners();
  }

  toggleLoadingFollowers() {
    _isLoadingFollwers = !_isLoadingFollwers;
    notifyListeners();
  }

  void addMember(int id) {
    if (_selectedFollowers.contains(id)) {
      _selectedFollowers.remove(id);
    } else {
      _selectedFollowers.add(id);
    }
    log('$_selectedFollowers');
    notifyListeners();
  }

  filterList(String query) {
    _filteredFollowerList = _followerFollowingList
        .where((follower) =>
            follower.username.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  clearMessages() {
    _messages.clear();
  }

  setGroup(JoinedChatGroupModel group) {
    _currentGroup = group;
    notifyListeners();
  }

  clearAll() {
    _messages.clear();
    _memberList.clear();
    _nextPageUrl = null;
    _totalPage = 1;
    _currentPage = 1;
    _currentGroup = null;
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    notifyListeners();
  }

  void scrollListener() async {
    final minScroll = scrollController.position.minScrollExtent;
    final currentScroll = scrollController.position.pixels;

    if (!_loadingNewItems) {
      if (currentScroll >= minScroll + 100) {
        if (_nextPageUrl != null) {
          _loadingNewItems = true;
          await fetchMessages(groupId: _groupId);
          _loadingNewItems = false;
        }
      }
    }
  }

  Future<void> pickGroupImage() async {
    try {
      XFile? image = await ImagePickerHelper.pickImageFromGallery();
      if (image != null) {
        groupImage = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      log('error $e');
    }
  }

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

  Future<void> fetchMessages({required int groupId}) async {
    try {
      _groupId = groupId;

      /// If the operation is periodic, fetch the latest page data.
      /// Otherwise, fetch data from the [nextPageUrl]. If [nextPageUrl] is null,
      /// the first page endpoint is used. Otherwise, the [nextPageUrl] endpoint is used.

      Response? response = await _repository.fetchMessages(
          nextPage: _nextPageUrl, groupId: groupId);
      if (response != null) {
        var responseBody = jsonDecode(response.body);
        List<dynamic> data = responseBody['data']['data'];
        log(data.length.toString());
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
        //     var message = GroupChatMessageModel.fromJson(item);
        //     if (_messages.any((message) => message.id == message.id)) {
        //       continue;
        //     }
        //     log(message.toString());
        //     _messages.insert(0, message);
        //   }
        // } else {
        _messages.addAll(
            data.map((json) => GroupChatMessageModel.fromJson(json)).toList());
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

  Future<void> markAsRead() async {
    try {
      await _repository.markAsRead(groupId: _groupId);
    } catch (e) {
      log('error marking messages as read $e');
    }
  }

  Future<void> fetchMembers() async {
    try {
      toggleLoadingMembers();
      _memberList.clear();
      await _repository
          .fetchMembers(groupId: _groupId)
          .then((followers) => _memberList.addAll(followers));
    } catch (e) {
      log('error fetching member $e');
    } finally {
      toggleLoadingMembers();
      notifyListeners();
    }
  }

  Future<void> sendMessage(
      {String? message, File? image, required UserProfile user}) async {
    try {
      Map<String, dynamic> map;
      if (message == null && image == null) {
        showSnackbar(message: 'Empty Message');
        return;
      } else if (message != null && image != null) {
        map = await _repository.sendMessageWithImage(
            groupId: _groupId, message: message, image: image);
      } else if (message == null) {
        map = await _repository.sendImage(groupId: _groupId, image: image!);
      } else {
        map =
            await _repository.sendMessage(groupId: _groupId, message: message);
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
        log(imageUrl.toString());
        _messages.insert(
          0,
          GroupChatMessageModel(
            id: map['chat_group_id'],
            chatGroupId: _groupId,
            userId: user.id,
            isRead: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            message: map['message'],
            imageUrl: imageUrl,
            user: GroupChatUserModel(
                id: user.id,
                name: user.name,
                username: user.username,
                profileImage: user.profileImage),
          ),
        );
      }
      messageController.clear();
      focusNode.unfocus();
      notifyListeners();
    } catch (e) {
      log('Error sending message: $e');
    }
  }

  Future<void> updateGroupInfo({
    required int groupId,
    String? name,
    int? isPrivate,
    String? description,
  }) async {
    try {
      if (_isBusy) {
        return;
      }
      toggleBusy();
      bool done = await _repository.updateGroupInfo(
          groupId: groupId,
          name: name,
          isPrivate: isPrivate,
          description: description);
      if (done) {
        currentGroup!.name = name ?? currentGroup!.name;
        if (isPrivate != null) {
          currentGroup!.isPrivate = isPrivate == 1;
        }
        currentGroup!.description = description ?? currentGroup!.description;
        log('updated group');
      }
    } catch (e) {
      log('Error updating group: $e');
    } finally {
      toggleBusy();
      notifyListeners();
    }
  }

  Future<void> fetchFollowersAndFollowing({required int userId}) async {
    try {
      toggleLoadingFollowers();
      _followerFollowingList.clear();
      await Future.wait([
        _chatRepository
            .fetchFollowers(userId: userId)
            .then((followers) => _followerFollowingList.addAll(followers)),
        _chatRepository
            .fetchFollowing(userId: userId)
            .then((following) => _followerFollowingList.addAll(following)),
      ]);
      _filteredFollowerList = _followerFollowingList;
    } catch (e) {
      log('error fetching followers $e');
    } finally {
      toggleLoadingFollowers();
      notifyListeners();
    }
  }

  Future<bool> addGroupMembers(
      {required int groupId, required List<int> members}) async {
    try {
      bool done =
          await _chatRepository.addMember(ids: members, groupId: groupId);

      if (done) {
        await fetchMembers();
        _selectedFollowers.clear();
      }
      notifyListeners();
      log('Added Member');

      return done;
    } catch (e) {
      log('Error Adding Member $e');
      return false;
    }
  }

  Future<bool> removeMemberFromGroup({required int memberId}) async {
    try {
      bool done = await _repository.removeMemberFromGroup(
          groupId: _groupId, memberId: memberId);

      if (done) {
        _memberList.removeWhere((member) => member.userId == memberId);
      }
      notifyListeners();
      log('removed Member');

      return done;
    } catch (e) {
      log('Error removing Member $e');
      return false;
    }
  }

  Future<bool> leaveGroup() async {
    try {
      bool done = await _repository.leaveGroup(groupId: _groupId);

      if (done) {
        log('left group');
      }
      notifyListeners();
      log('left group');

      return done;
    } catch (e) {
      log('Error leaving group $e');
      return false;
    }
  }

  Future<bool> deleteGroup() async {
    try {
      bool done = await _repository.deleteGroup(groupId: _groupId);
      if (done) {
        log('deleted group');
      }
      return done;
    } catch (e) {
      log('Error deleting group: $e');
      return false;
    }
  }
}
