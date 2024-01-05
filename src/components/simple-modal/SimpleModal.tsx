import * as React from 'react';
import {Portal, Chip, useTheme, Button, Dialog, Text, FAB} from 'react-native-paper';
import {ScrollView, View} from "react-native";


const SimpleModal = ({
                         children,
                         title,
                         text,
                         icon = null,
                         onAccept = null,
                         onDecline = null
                     }) => {

    const [visible, setVisible] = React.useState(false);

    const showDialog = () => setVisible(true);
    const hideDialog = () => {
        setVisible(false);
    };

    const onAcceptBtn = () => {
        if (onAccept) onAccept();
        setVisible(false);
    }

    const onDeclineBtn = () => {
        if (onDecline) onDecline();
        setVisible(false);
    }

    return (
        <View style={{display: "flex", justifyContent: "center"}}>
            <Chip icon={icon} closeIcon="square-edit-outline"
                  onPress={showDialog}
                  onClose={showDialog}
            >
                {text}
            </Chip>
            <Portal>
                <Dialog visible={visible} onDismiss={hideDialog} >
                    <Dialog.Title>{title}</Dialog.Title>
                    <Dialog.Content>{children}</Dialog.Content>
                    <Dialog.Actions>
                        <FAB icon="close" size={'small'} onPress={onDeclineBtn}
                             variant={'tertiary'} color={useTheme().colors.error} />
                        <FAB icon="check" size={'small'} onPress={onAcceptBtn} />
                    </Dialog.Actions>
                </Dialog>
            </Portal>
        </View>
    );
};

export default SimpleModal;