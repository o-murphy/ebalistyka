import { createNavigationContainerRef } from '@react-navigation/native';

export const navigationRef = createNavigationContainerRef()

export function navigate(name: string) {
    if (navigationRef.isReady()) {
        navigationRef.navigate(name);
    }
}

export function getCurrentRoute() {
    if (navigationRef.isReady()) {
        return navigationRef.getCurrentRoute();
    }
    return null;
}
