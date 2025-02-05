import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/src/common/utils/custom_snackbar.dart';
import '/src/common/utils/image_picker_helper.dart';
import '/src/features/follower/models/follower_model.dart';
import '/src/features/chat/group_chat/model/joined_chat_group_model.dart';
import '../repository/group_chat_repository.dart';

class GroupChatController extends ChangeNotifier {
  final GroupChatRepository _repository = GroupChatRepository();
  //Creating a group
  bool _isPrivate = false;
  bool _isLoading = false;
  bool _firstTimeLoading = true;
  bool _isLoadingFollwers = false;
  bool _isBusy = false;
  bool _showImageWarning = false;
  String _selectedPrivacyValue = 'Public';
  File? _groupImage;
  List<JoinedChatGroupModel> _groupList = [];
  final List<int> _memberList = [];
  final List<FollowerModel> _followerFollowingList = [];
  List<FollowerModel> _filteredFollowerList = [];

  bool get isPrivate => _isPrivate;
  bool get isLoading => _isLoading;
  bool get firstTimeLoading => _firstTimeLoading;
  bool get isLoadingFollwers => _isLoadingFollwers;
  bool get isBusy => _isBusy;
  bool get showImageWarning => _showImageWarning;
  String get selectedPrivacyValue => _selectedPrivacyValue;
  File? get groupImage => _groupImage;
  List<JoinedChatGroupModel> get groupList => _groupList;
  List<int> get memberList => _memberList;
  List<FollowerModel> get followerFollowingList => _followerFollowingList;
  List<FollowerModel> get filteredFollowerList => _filteredFollowerList;

  toggleWarning(bool value) {
    _showImageWarning = value;
    notifyListeners();
  }

  toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  toggleLoadingFollowers() {
    _isLoadingFollwers = !_isLoadingFollwers;
    notifyListeners();
  }

  toggleBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  filterList(String query) {
    _filteredFollowerList = _followerFollowingList
        .where((follower) =>
            follower.username.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  changeGroupPrivacy(String? value) {
    _selectedPrivacyValue = value ?? '';
    if (_selectedPrivacyValue == 'Private') {
      _isPrivate = true;
    } else {
      _isPrivate = false;
    }
    notifyListeners();
  }

  void addMember(int id) {
    if (_memberList.contains(id)) {
      _memberList.remove(id);
    } else {
      _memberList.add(id);
    }
    log('$_memberList');
    notifyListeners();
  }

  void deleteGroup(int groupId) {
    _groupList.removeWhere((group) => group.id == groupId);
    notifyListeners();
  }

  void clearMembers() {
    _groupImage = null;
    toggleWarning(false);
    _memberList.clear();
    notifyListeners();
  }

  Future<void> pickImage() async {
    try {
      XFile? image = await ImagePickerHelper.pickImageFromGallery();
      if (image != null) {
        _groupImage = File(image.path);
        toggleWarning(false);
        notifyListeners();
      }
    } catch (e) {
      log('error $e');
    }
  }

  Future<void> fetchGroups() async {
    try {
      toggleLoading();
      _groupList = await _repository.fetchGroups();
    } catch (e) {
      showSnackbar(message: 'Error fetching group $e', isError: true);
    } finally {
      _firstTimeLoading = false;
      toggleLoading();
      notifyListeners();
    }
  }

  Future<void> createGroup(BuildContext context,
      {required String name, required String description}) async {
    try {
      int? id = await _repository.createGroup(
          name: name, isPrivate: _isPrivate, description: description);
      if (id != null) {
        bool iconAdded = false;
        bool memberAdded = false;
        await Future.wait([
          if (_groupImage != null)
            addGroupIcon(groupId: id, icon: _groupImage!)
                .then((value) => iconAdded = value.isNotEmpty),
          if (_memberList.isNotEmpty)
            addGroupMembers(members: _memberList, groupId: id)
                .then((value) => memberAdded = value),
        ]);
        log('iconAdded: $iconAdded');
        log('memberAdded: $memberAdded');
      }
      log('Group created successfully');
    } catch (e) {
      showSnackbar(message: 'Error creating group $e', isError: true);
    }
  }

  Future<bool> addGroupMembers(
      {required int groupId, required List<int> members}) async {
    try {
      bool done = await _repository.addMember(ids: members, groupId: groupId);

      notifyListeners();
      log('Added Member');

      return done;
    } catch (e) {
      log('Error Adding Member $e');
      return false;
    }
  }

  Future<String> addGroupIcon(
      {required int groupId, required File icon}) async {
    try {
      String iconUrl =
          await _repository.addGroupIcon(groupId: groupId, file: icon);
      if (iconUrl.isNotEmpty) {
        for (var group in _groupList) {
          if (group.id == groupId) {
            group.iconUrl = iconUrl;
          }
        }
      }
      notifyListeners();
      log('Added icon');
      return iconUrl;
    } catch (e) {
      log('Error Adding Icon $e');
      return '';
    }
  }

  Future<void> fetchFollowersAndFollowing({required int userId}) async {
    try {
      toggleLoadingFollowers();
      _followerFollowingList.clear();
      await Future.wait([
        _repository
            .fetchFollowers(userId: userId)
            .then((followers) => _followerFollowingList.addAll(followers)),
        _repository
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

  Future<void> togglePin({required int groupId}) async {
    try {
      toggleBusy(true);

      bool done = await _repository.togglePin(groupId: groupId);
      if (done) {
        for (var group in _groupList) {
          if (group.id == groupId) {
            group.isPinned = !group.isPinned;
          }
        }
        notifyListeners();
        log('Pinned');
      }
    } catch (e) {
      log('error Pinning $e');
    } finally {
      toggleBusy(false);
    }
  }

  Future<void> toggleFavorite({required int groupId}) async {
    try {
      toggleBusy(true);
      bool done = await _repository.toggleFavorite(groupId: groupId);
      if (done) {
        for (var group in _groupList) {
          if (group.id == groupId) {
            group.isFavorite = !group.isFavorite;
          }
        }
        notifyListeners();
        log('Favorited');
      }
    } catch (e) {
      log('error Favoriting $e');
    } finally {
      toggleBusy(false);
    }
  }
}
