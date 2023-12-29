import * as React from 'react';
import {Modal, Portal, Text, Chip, useTheme, Button} from 'react-native-paper';
import {View, StyleSheet} from "react-native";
import styleSheet from "../../styles/stylesheet";


const SimpleModal = ({children, title, text, icon = null, visible = false}) => {

    const theme = useTheme()

    const [is_visible, setVisible] = React.useState(visible);

    const showModal = () => setVisible(true);
    const hideModal = () => setVisible(false);

    const modalSimpleStyle = StyleSheet.create(styleSheet.modal.simple)
    const textStyle = StyleSheet.compose(modalSimpleStyle.title, null)
    const containerStyle = StyleSheet.compose(modalSimpleStyle.container, {backgroundColor: theme.colors.background})

    return (
        <View style={{display: "flex", justifyContent: "center"}}>
            <Chip icon={icon} closeIcon="square-edit-outline"
                // style={styleSheet.chip.measure}
                // textStyle={styleSheet.chip.measure_text}
                  onPress={showModal}
                  onClose={showModal}
            >
                {text}
            </Chip>
            <Portal>
                <Modal visible={is_visible} onDismiss={hideModal} contentContainerStyle={containerStyle}>
                    <Text variant="titleLarge" style={textStyle}>
                        {title}
                    </Text>
                    {children}
                    <Button style={styleSheet.modal.simple.closeButton}
                            icon={"check"} mode={"elevated"} onPress={hideModal}>Ok</Button>
                </Modal>
            </Portal>
        </View>
        // {/*</PaperProvider>*/}
    );
};

export default SimpleModal;