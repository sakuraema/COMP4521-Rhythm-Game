using System.Collections;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

public class Autoplay : MonoBehaviour
{
    public GameObject [ ] particles;
    public Text display;

    public void OnEnable ( )
    {
        StopAllCoroutines ( );
        StartCoroutine ( CycleThroughParticles() );
    }

    private IEnumerator CycleThroughParticles ( )
    {
        var nextItem = 0;
        yield return new WaitForSeconds ( 2f );

        while ( true )
        {
            particles [ nextItem ].SetActive ( true );
            if ( display ) display.text = particles [ nextItem ].name;

            yield return new WaitForSeconds ( 7f );

            particles [ nextItem ].SetActive ( false);

            nextItem++;
            nextItem = (nextItem >= particles.Length) ? 0 : nextItem;
        }
    }


#if UNITY_EDITOR
    private void OnValidate ( )
    {
        particles = particles.Where ( _item => _item != null).ToArray();
    }
#endif
}
