using UnityEngine;
using UnityEngine.UI;

public class SwitchHight : MonoBehaviour
{
    public Vector2 hightRange = new Vector2 ( 0f,  4f);
    public Slider slider;


    Vector3 adjustedPosition;

    private void Update ( )
    {
        adjustedPosition = transform.localPosition;
        adjustedPosition.y = 
            Mathf.Lerp ( adjustedPosition.y , 
            Mathf.Lerp(hightRange.x, hightRange.y, slider.value), 
            Time.smoothDeltaTime);

        adjustedPosition.y = 
            Mathf.MoveTowards ( adjustedPosition.y, 
            Mathf.MoveTowards ( hightRange.x, hightRange.y, slider.value ), 
            Time.smoothDeltaTime );

        transform.localPosition = adjustedPosition;   
    }
}
