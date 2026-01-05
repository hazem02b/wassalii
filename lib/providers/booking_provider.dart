import 'package:flutter/foundation.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';

class BookingProvider with ChangeNotifier {
  final BookingService _bookingService = BookingService();
  
  List<Booking> _bookings = [];
  Booking? _selectedBooking;
  bool _isLoading = false;
  String? _error;
  
  List<Booking> get bookings => _bookings;
  Booking? get selectedBooking => _selectedBooking;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  List<Booking> get pendingBookings => 
      _bookings.where((b) => b.status == BookingStatus.pending).toList();
  
  List<Booking> get activeBookings => 
      _bookings.where((b) => b.status == BookingStatus.accepted || 
                             b.status == BookingStatus.inProgress).toList();
  
  List<Booking> get completedBookings => 
      _bookings.where((b) => b.status == BookingStatus.completed).toList();
  
  Future<void> fetchBookings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _bookings = await _bookingService.getBookings();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> fetchBookingById(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _selectedBooking = await _bookingService.getBookingById(id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<bool> createBooking(Map<String, dynamic> bookingData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final booking = await _bookingService.createBooking(bookingData);
      _bookings.insert(0, booking);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> acceptBooking(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final booking = await _bookingService.acceptBooking(id);
      _updateBookingInList(booking);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> completeBooking(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final booking = await _bookingService.completeBooking(id);
      _updateBookingInList(booking);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<bool> cancelBooking(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final booking = await _bookingService.cancelBooking(id);
      _updateBookingInList(booking);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  void _updateBookingInList(Booking booking) {
    final index = _bookings.indexWhere((b) => b.id == booking.id);
    if (index != -1) {
      _bookings[index] = booking;
    }
    if (_selectedBooking?.id == booking.id) {
      _selectedBooking = booking;
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
