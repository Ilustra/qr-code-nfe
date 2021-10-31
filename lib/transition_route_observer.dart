import 'package:flutter/material.dart';

/// Implementation copied from [RouteObserver] to notifies [TransitionRouteAware]s of changes to the
/// state of their [Route], plus when the route transition finished
class TransitionRouteObserver<R extends TransitionRoute<dynamic>?>
    extends NavigatorObserver {
  final Map<R, Set<TransitionRouteAware>> _listeners =
      <R, Set<TransitionRouteAware>>{};

  /// Subscribe [routeAware] to be informed about changes to [route].
  ///
  /// Going forward, [routeAware] will be informed about qualifying changes
  /// to [route], e.g. when [route] is covered by another route or when [route]
  /// is popped off the [Navigator] stack.
  void subscribe(TransitionRouteAware routeAware, R route) {
    assert(route != null);
    final subscribers =
        _listeners.putIfAbsent(route, () => <TransitionRouteAware>{});
    if (subscribers.add(routeAware)) {
      routeAware.didPush();
      Future.delayed(route!.transitionDuration, () {
        routeAware.didPushAfterTransition();
      });
    }
  }

  /// Unsubscribe [routeAware].
  ///
  /// [routeAware] is no longer informed about changes to its route. If the given argument was
  /// subscribed to multiple types, this will unregister it (once) from each type.
  void unsubscribe(TransitionRouteAware routeAware) {
    for (var route in _listeners.keys) {
      final subscribers = _listeners[route];
      subscribers?.remove(routeAware);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is R && previousRoute is R) {
      final previousSubscribers = _listeners[previousRoute]?.toList();

      if (previousSubscribers != null) {
        for (var routeAware in previousSubscribers) {
          routeAware.didPopNext();
        }
      }

      final subscribers = _listeners[route as R]?.toList();

      if (subscribers != null) {
        for (var routeAware in subscribers) {
          routeAware.didPop();
        }
      }
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is R && previousRoute is R) {
      final previousSubscribers = _listeners[previousRoute];

      if (previousSubscribers != null) {
        for (var routeAware in previousSubscribers) {
          routeAware.didPushNext();
        }
      }
    }
  }
}

/// An interface for objects that are aware of their current [TransitionRoute].
///
/// This is used with [TransitionRouteObserver] to make a widget aware of changes to the
/// [Navigator]'s session history.

/// Uma interface para objetos que estão cientes de seu [TransitionRoute] atual.
///
/// Isso é usado com [TransitionRouteObserver] para tornar um widget ciente das mudanças no
/// [Navigator] histórico da sessão.
///
abstract class TransitionRouteAware {
  /// Chamado quando a rota principal foi retirada, e a rota atual
  /// Aparece.
  void didPopNext() {}

  /// Chamado quando a rota atual foi empurrada.
  void didPush() {}

  /// Chamado quando a rota atual foi empurrada e terminou a transição
  void didPushAfterTransition() {}

  /// Chamado quando a rota atual foi interrompida.
  void didPop() {}

  /// Chamado quando uma nova rota foi empurrada, e a rota atual é não
  /// mais visível.
  void didPushNext() {}
}
